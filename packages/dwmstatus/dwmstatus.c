/*
 * Copy me if you can.
 * by 20h
 */

#define _BSD_SOURCE
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <strings.h>
#include <sys/time.h>
#include <time.h>
#include <sys/types.h>
#include <sys/wait.h>

#include <X11/Xlib.h>

#include "nvidia_temp.h"

char *tzutc = "UTC";
char *tzcopenhagen = "Europe/Copenhagen";

static Display *dpy;

char *
smprintf(char *fmt, ...)
{
	va_list fmtargs;
	char *ret;
	int len;

	va_start(fmtargs, fmt);
	len = vsnprintf(NULL, 0, fmt, fmtargs);
	va_end(fmtargs);

	ret = malloc(++len);
	if (ret == NULL) {
		perror("malloc");
		exit(1);
	}

	va_start(fmtargs, fmt);
	vsnprintf(ret, len, fmt, fmtargs);
	va_end(fmtargs);

	return ret;
}

void
settz(char *tzname)
{
	setenv("TZ", tzname, 1);
}

char *
mktimes(char *fmt, char *tzname)
{
	char buf[129];
	time_t tim;
	struct tm *timtm;

	settz(tzname);
	tim = time(NULL);
	timtm = localtime(&tim);
	if (timtm == NULL)
		return smprintf("");

	if (!strftime(buf, sizeof(buf)-1, fmt, timtm)) {
		fprintf(stderr, "strftime == 0\n");
		return smprintf("");
	}

	return smprintf("%s", buf);
}

void
setstatus(char *str)
{
	XStoreName(dpy, DefaultRootWindow(dpy), str);
	XSync(dpy, False);
}

char *
loadavg(void)
{
	double avgs[3];

	if (getloadavg(avgs, 3) < 0)
		return smprintf("");

	return smprintf("%.2f %.2f %.2f", avgs[0], avgs[1], avgs[2]);
}

char *
readfile(char *base, char *file)
{
	char *path, line[513];
	FILE *fd;

	memset(line, 0, sizeof(line));

	path = smprintf("%s/%s", base, file);
	fd = fopen(path, "r");
	free(path);
	if (fd == NULL)
		return NULL;

	if (fgets(line, sizeof(line)-1, fd) == NULL)
		return NULL;
	fclose(fd);

	return smprintf("%s", line);
}

char *
getbattery(char *base)
{
	char *co, status;
	int descap, remcap;

	descap = -1;
	remcap = -1;

	co = readfile(base, "present");
	if (co == NULL)
		return smprintf("");
	if (co[0] != '1') {
		free(co);
		return smprintf("not present");
	}
	free(co);

	co = readfile(base, "charge_full_design");
	if (co == NULL) {
		co = readfile(base, "energy_full");
		if (co == NULL)
			return smprintf("");
	}
	sscanf(co, "%d", &descap);
	free(co);

	co = readfile(base, "charge_now");
	if (co == NULL) {
		co = readfile(base, "energy_now");
		if (co == NULL)
			return smprintf("");
	}
	sscanf(co, "%d", &remcap);
	free(co);

	co = readfile(base, "status");
	if (!strncmp(co, "Discharging", 11)) {
		status = '-';
	} else if(!strncmp(co, "Charging", 8)) {
		status = '+';
	} else {
		status = '?';
	}

	if (remcap < 0 || descap < 0)
		return smprintf("invalid");

	return smprintf("%.0f%%%c", ((float)remcap / (float)descap) * 100, status); // TODO: left justify this string
}

char *
gettemperature(char *base, char *sensor)
{
	char *co;

	co = readfile(base, sensor);
	if (co == NULL)
		return smprintf("");
	return smprintf("%02.0f°C", atof(co) / 1000);
}

char *
execscript(char *cmd)
{
	FILE *fp;
	char retval[1025], *rv;

	memset(retval, 0, sizeof(retval));

	fp = popen(cmd, "r");
	if (fp == NULL)
		return smprintf("");

	rv = fgets(retval, sizeof(retval), fp);
	pclose(fp);
	if (rv == NULL)
		return smprintf("");
	retval[strlen(retval)-1] = '\0';

	return smprintf("%s", retval);
}

int
main(void)
{
   //thrd_t thread;

	char *status;
	//char *avgs;
	char *bat;
	//char *tmar;
	//char *tmutc;
	char *tmcph;
	char *cpu_temp;
	//char *t1;
	//char *kbmap;
	time_t seconds;
   char *gpu_temp;

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "dwmstatus: cannot open display.\n");
		return 1;
	}

   //if (!nvidia_init()) {
   //    fprintf(stderr, "Warning: NVIDIA GPU monitoring failed to initialize\n");
   //}

	for (;; sleep(1)) {
		//avgs = loadavg();
		bat = getbattery("/sys/class/power_supply/BAT0");
		//tmar = mktimes("%H:%M", tzargentina);
		//tmutc = mktimes("%H:%M", tzutc);
		tmcph = mktimes("%a %d %b %H:%M %Z %Y", tzcopenhagen);
		seconds = time(NULL);
      seconds = seconds - (seconds % 5);
		//kbmap = execscript("setxkbmap -query | grep layout | cut -d':' -f 2- | tr -d ' '");
		cpu_temp = gettemperature("/sys/devices/virtual/thermal/thermal_zone0", "temp");
		//t1 = gettemperature("/sys/devices/virtual/thermal/thermal_zone1", "temp");
      
		//gpu_temp = execscript("nvidia-smi --format=csv,noheader --query-gpu \"temperature.gpu\"");
      //gpu_temp = nvidia_get_temp();

		status = smprintf("T: CPU %s – GPU %s°C │ B: %s │ Unix: %ld │ %s",
				           cpu_temp,"N/A", bat,      seconds,tmcph);
		setstatus(status);

		//free(kbmap);
		free(cpu_temp);
		//free(t1);
      //free(gpu_temp);
		//free(avgs);
		free(bat);
		//free(tmar);
		//free(tmutc);
		free(tmcph);
		free(status);
	}

   //nvidia_cleanup();
	XCloseDisplay(dpy);

	return 0;
}


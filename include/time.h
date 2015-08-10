#ifndef __TIME_H_
#define __TIME_H_
#include <types.h>

enum months {
        JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY,
        AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER
};

struct tm {
        int tm_sec;     //!< Seconds.
        int tm_min;     //!< Minutes.
        int tm_hour;    //!< Hours.
        int tm_mday;    //!< Day of the month.
        int tm_mon;     //!< Month.
        int tm_year;    //!< Year.
        int tm_wday;    //!< Day of the week.
        int tm_yday;    //!< Day in the year.
        int tm_isdst;   //!< Daylight saving time.
};

void calcDate(struct tm *tm);
//int monthinit(char*)

#endif

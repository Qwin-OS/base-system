#include <stdio.h>

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


void calcDate(struct tm *tm)
{
  uint32_t seconds, minutes, hours, days, year, month;
  uint32_t dayOfWeek;
  seconds = time();

  /* calculate minutes */
  minutes  = seconds / 60;
  seconds -= minutes * 60;
  /* calculate hours */
  hours    = minutes / 60;
  minutes -= hours   * 60;
  /* calculate days */
  days     = hours   / 24;
  hours   -= days    * 24;

  /* Unix time starts in 1970 on a Thursday */
  year      = 1970;
  dayOfWeek = 4;

  while(1)
  {
    int     leapYear   = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
    uint16_t daysInYear = leapYear ? 366 : 365;
    if (days >= daysInYear)
    {
      dayOfWeek += leapYear ? 2 : 1;
      days      -= daysInYear;
      if (dayOfWeek >= 7)
        dayOfWeek -= 7;
      ++year;
    }
    else
    {
      tm->tm_yday = days;
      dayOfWeek  += days;
      dayOfWeek  %= 7;

      /* calculate the month and day */
      static const uint8_t daysInMonth[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
      for(month = 0; month < 12; ++month)
      {
        uint8_t dim = daysInMonth[month];

        /* add a day to feburary if this is a leap year */
        if (month == 1 && leapYear)
          ++dim;

        if (days >= dim)
          days -= dim;
        else
          break;
      }
      break;
    }
  }

  tm->tm_sec  = seconds;
  tm->tm_min  = minutes;
  tm->tm_hour = hours;
  tm->tm_mday = days + 1;
  tm->tm_mon  = month;
  tm->tm_year = year;
  tm->tm_wday = dayOfWeek;
}

int
main(void)
{
   struct tm *time;
   calcDate(time);
   printf("timestamp:%d %d %d:%d:%d\n",time->tm_mon,time->tm_mday,time->tm_hour,time->tm_min,time->tm_sec);
}

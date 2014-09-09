#ifndef _RTC_H_
#define _RTC_H_

#define bcd2dec(bcd) ((((bcd) >> 4) * 0xa) + ((bcd) & 0xf))

typedef union {
  unsigned long time;
  struct {
    unsigned long hour:5;
    unsigned long minute:6;
    unsigned long second:6;
  }fields;
}TIME;

typedef union {
  unsigned long date;
  struct {
    unsigned long dow:3; /*Day of week*/
    unsigned long dom:5; /*Day of month*/
    unsigned long month:4;
    unsigned long year:7;
  }fields;
}DATE;


void init_rtc();
void get_date(DATE *date);
void get_time(TIME *time);

#endif

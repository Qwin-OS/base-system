void dev_null_init(void);
void dev_zero_init(void);
void dev_tty_init(void);

void devinit(void)
{
dev_null_init();
dev_zero_init();
dev_tty_init();
}

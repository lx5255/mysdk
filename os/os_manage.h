#ifndef _OS_MANAGE_ 
#define _OS_MANAGE_ 

typedef enum{ 
   OS_OK,
   OS_PARAME_ERR,
   OS_PALT_ERR,
}OS_RET;

typedef struct{
    char *name;
    uint32 stack_size;
    uint32 msg_size;
    OS_RET (*thread_func)(void *arg);
    OS_RET (*thread_before)();
    OS_RET (*thread_after)();
}thread_def;


typedef struct{
    OS_RET (*thread_creat)(thread_def *def, void *arg);
    OS_RET (*os_start)();
    OS_RET (*os_delay)(uint32 delay_ms);
    uint32 (*os_sys_tick)(void);
    OS_RET (*os_sem_creat)();
    OS_RET (*os_sem_wait)();
    OS_RET (*os_sem_relese)();
}os_io;

OS_RET os_start();
OS_RET os_thread_creat(thread_def *def, void *arg);
OS_RET os_thread_delete_by_name(char *name);
OS_RET os_delay(uint32 delay_ms);
uint32 os_sys_tick(void);
OS_RET os_sem_creat();
OS_RET os_sem_wait();
OS_RET os_sem_relese();
#endif

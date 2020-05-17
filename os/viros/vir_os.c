u8 task_run()
{
    u8 res;
    chain_point *task_point;
    while(1)
    {
        if(task_chain == 0)
        {
            return TM_TASK_NOEXIST;
        }
        task_point = task_chain;
        //				task_printf("b");
        while(task_point)
        {
            cur_task = task_point->data;
            if(cur_task->task_func(0))
                return TM_RUN_ERR;  //运行错误

            //						task_printf("c");
            task_point = task_point->next;
        }
    }
}

//创建一个任务
u8 creat_task(task_ls *task_list, u16 msg_size)
{
    //task_ls *task_list = (task_ls *)malloc(sizeof(task_ls));
    if(task_list == NULL)
        return TM_PTR_NULL;

    if(task_list->task_init)  //任务启动前初始化
    {
        if(task_list->task_init())
            return TM_INIT_FAIL;//初始化失败
    }
    task_list->q_msg = (q_msg_struct *)new_q_msg(task_list->name, msg_size);
    if(task_list->q_msg == 0)
        return TM_MALLOC_ERR;

    add_chain_point(&task_chain, task_list);//将任务挂到运行链表
    task_list->run_flag = 1;  
    return 0;
}

//删除一个任务
u8 del_task(char *name)
{
    task_ls *task_list;
    chain_point *chain_poin = task_chain;

    while(chain_poin)
    {
        task_list = task_chain->data;
        if(cmp_str(name, task_list->name))
        {
            if(task_list->task_exit)
                task_list->task_exit();

            del_chain_point(&task_chain, task_list);
            free_q_msg(task_list->q_msg);
            //   free(task_list);
            return 0;
        }
        chain_poin = chain_poin->next;
    }
    return TM_TASK_NOEXIST;   
}

//post消息到线程
u8 taskq_post(char *task_name, u32 msg)
{
    task_ls *task_list;
    chain_point *chain_poin = task_chain;

    while(chain_poin)
    {
        task_list = chain_poin->data;
        if(cmp_str((const char *)task_name, (const char *)task_list->name))
        {
            u8 res;
            res =  q_post(task_list->q_msg, msg);
            if(res)
                return TM_OTHER;
            else
                return 0;
        }
        chain_poin = chain_poin->next;
    }

    return 1;
}

//获取一个消息
u32 taskq_pend(void)
{
    u32 msg;
    if(cur_task == 0)
        return 0xffffffff;

    msg = q_pend(cur_task->q_msg);

    return msg;
}

//发送4个消息
u8 task_post_msg(char *name, u8 len, ...)
{
    u16 msg_cnt;
    u32 msg[4] = {0,0,0,0};
    u8 cnt = 0, res;
    va_list ap;
    if(cur_task == 0)
    {
        return TM_TASK_NOEXIST;
    }
    msg_cnt = get_q_msg_free(cur_task->q_msg);
    if(msg_cnt < len)
    {
        return TM_OVER;
    }
    va_start(ap,len);

    while(cnt<len)
    {
        msg[cnt++] = va_arg(ap, int);
    }
    va_end(ap);

    for(cnt=0; cnt<4;)
    {
        res = taskq_post(name, msg[cnt++]);
        if(res)
            return TM_OTHER;
    }
    return 0;
}


//获取4个消息
u8 task_pend_msg(u32 *msg)
{
    u8 cnt;
    if(get_q_msg_num(cur_task->q_msg)<4)
    {
        msg[0] = 0xffffffff;
        return TM_NO_MSG;
    }
    for(cnt = 0; cnt<4;cnt++)
        msg[cnt] =  taskq_pend();

    return 0;
}

u16 get_task_msg_num()
{
    return cur_task->q_msg->msg_num;
}



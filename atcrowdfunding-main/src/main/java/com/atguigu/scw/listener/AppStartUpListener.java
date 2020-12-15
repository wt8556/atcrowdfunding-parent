package com.atguigu.scw.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

//listener还需要将自己注册到服务器中：将全类名配置到web.xml中
public class AppStartUpListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        //将上下文路径存到application域中
        sce.getServletContext().setAttribute("PATH",sce.getServletContext().getContextPath());
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }
}

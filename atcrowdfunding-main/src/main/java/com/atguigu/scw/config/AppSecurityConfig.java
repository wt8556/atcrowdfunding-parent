package com.atguigu.scw.config;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.MessageDigestPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableWebSecurity //启用springSecurity的功能
@EnableGlobalMethodSecurity(prePostEnabled = true) //启用security通过PreAuthorize注解控制方法的访问权限
public class AppSecurityConfig extends WebSecurityConfigurerAdapter {

    //向spring容器中注入一个PasswordEncoder的对象，springsecurity会自动获取使用
    @Bean //在方法上使用可以将方法的返回值对象注入到容器中
    public PasswordEncoder getPasswordEncoder(){
        //md5的加密处理器
        return new MessageDigestPasswordEncoder("md5");
    }
    @Autowired
    UserDetailsService userDetailsService;
    //认证配置
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        //super.configure(auth);
        //springsecurity认为数据库密码数据必须采用加密的方式保存。在认证时需要指定密码加密的工具对象
//        auth.inMemoryAuthentication() //在内存中写死账号密码信息,一般测试使用
//            .withUser("admin").password("e10adc3949ba59abbe56e057f20f883e").roles("ADMIN" , "BOSS")//会自动在每个字符串前拼接"ROLE_"前缀
//            .and()
//            .withUser("laozhang").password("e10adc3949ba59abbe56e057f20f883e").authorities("user:add" , "user:delete");

        //基于数据库的认证:  编写业务类根据登录账号查询主体对象的信息(账号+权限角色集合) ，有springsecurity验证数据库查询到的密码和浏览器提交的密码是否一致

        auth.userDetailsService(userDetailsService);
    }
    //授权配置
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        //1 首页静态资源和登录页面 所有人都可以访问，无需权限检查
        //authorizeRequests():开始对所有的资源配置授权
        http.authorizeRequests()//
                //hasAnyAuthority()拥有列表中的任意权限字符串即可访问
                //hasAnyRole()拥有列表中的任意角色可以访问
                //authenticated()登录成功即可访问不检查权限
                //permitAll()所有人都可以访问无需认证
                //配置类中所有的路径都是浏览器访问的绝对路径
                .antMatchers("/","/index","/index.html","/static/**","/admin/login.html").permitAll()
                //anyRequest()除了上面指定路径的配置以外其他的所有请求的配置
                //.antMatchers("/admin/delete/*").hasAnyAuthority("user:delete")
                .anyRequest().authenticated();
        // 登录和注销提交请求时必须使用post方式提交
        // 禁用CSRF功能：  防跨站点攻击
        http.csrf().disable();

        //2 springsecurity接管登录请求
        //指定登录请求提交的路径、登录表单提交的请求参数key、登录成功和登录失败的跳转
        http.formLogin()
                .loginPage("/admin/login.html") //登录页面的配置
                .loginProcessingUrl("/admin/login") //登录表单提交的地址
                .usernameParameter("loginacct") //登录表单提交登录账号的key
                .passwordParameter("userpswd") //登录表单提交密码的key
                .successHandler(new AuthenticationSuccessHandler() {
                    @Override
                    public void onAuthenticationSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
                        //重定向
                        httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/admin/main.html");
                    }
                })//登录成功跳转的处理配置
                .failureHandler(new AuthenticationFailureHandler() {
                    @Override
                    public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException e) throws IOException, ServletException {
                        //转发到登录页面
                        httpServletRequest.setAttribute("errorMsg","账号或密码错误.....");
                        httpServletRequest.getRequestDispatcher("/WEB-INF/pages//admin/login.jsp").forward(httpServletRequest,httpServletResponse);
                    }
                }); //登录失败处理的配置

        //3 springsecurity接管注销请求
        http.logout()
                .logoutUrl("/admin/logout") //注销提交的请求url
                .logoutSuccessHandler(new LogoutSuccessHandler() {
                    @Override
                    public void onLogoutSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
                        httpServletResponse.sendRedirect(httpServletRequest.getContextPath() + "/admin/login.html");
                    }
                });//注销成功的处理配置
        //4 配置访问未授权页面的异常处理
        http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {
                //异步请求报文头中包含：X-Requested-With: XMLHttpRequest
                if ("XMLHttpRequest".equals(httpServletRequest.getHeader("X-Requested-With"))){
                    httpServletResponse.setContentType("application/json;charest=UTF-8");
                    //异步请求   如果异步访问的资源无权访问，可以响应一个简洁的错误信息即可
                    Map map = new HashMap<>();
                    map.put("code",10001); //10001表示403
                    map.put("msg",e.getMessage());
                    httpServletResponse.getWriter().write(new Gson().toJson(map));
                }else{
                   //获取异常信息
                   String errorMsg = e.getMessage();
                   httpServletRequest.setAttribute("errorMsg", errorMsg);
                   //转发到异常页面
                    httpServletRequest.getRequestDispatcher("/WEB-INF/pages/error/403.jsp").forward(httpServletRequest,httpServletResponse);
                }
            }
        });
    }
}

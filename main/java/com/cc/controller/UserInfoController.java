package com.cc.controller;

import com.cc.model.PageUtil;
import com.cc.model.UserInfo;
import com.cc.service.UserInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserInfoController {
    @Autowired
    private UserInfoService userInfoService;
    @Autowired
    private  HttpServletRequest request;
    @RequestMapping("/main")
    public String main(){
        return "/main";
    }
    /**
     * 用户登入
     * @param userInfo
     * @return
     */
    @RequestMapping("/login")
    public String login(UserInfo userInfo, Model model){
        String msg="";
        //根据登入账号判断该用户是否存在
        UserInfo user = userInfoService.selectUserByLoginName(userInfo.getLoginName());
        if(user==null){
            msg="该用户不存在！";
        }else{
            if(user.getPassword().equals(userInfo.getPassword())){
                //验证成功进入主界面
                //model.addAttribute("userInfo",user);
                this.request.getSession().setAttribute("userInfo",user);//王毕陈在这里放大作用域，不要改动，大家也可以用这个
                switch (user.getIdentity()){
                    case "boss":
                        return "redirect:/user/main";
                    case "DPManager":
                        return "redirect:/warehouse/selectAll";
                    case "sales":
                        return "redirect:/items/selectAll";
                }

            }else{
                msg="密码错误！";
            }
        }
        model.addAttribute("msg",msg);
        return "/login";
    }
    /**
     * 用户注册
     * @param userInfo
     * @return
     */
    @RequestMapping("/register")
    public String register(UserInfo userInfo,Model model){
        try {
            UserInfo user = userInfoService.selectUserByLoginName(userInfo.getLoginName());
            if(user!=null){
                model.addAttribute("msg","注册失败,该登入名已存在！");
            }else{
                userInfoService.insertUser(userInfo);
                model.addAttribute("msg","注册成功，请登入！");
            }
        }catch (Exception e){
            model.addAttribute("msg","注册失败！");
            e.printStackTrace();
        }
        return "/login";
    }

    /**
     * 退出系统
     * @return
     */
    @RequestMapping("/loginOut")
    public String loginOut(HttpServletRequest request){
        //清空session
        request.getSession().invalidate();
        return "login";
    }

    /**
     * 新增或编辑用户信息
     * @param userInfo
     * @param model
     * @return
     */
    @RequestMapping("/addUser")
    public String addUser(UserInfo userInfo,Model model,String myid){
        try {
            UserInfo user = userInfoService.selectUserByLoginName(userInfo.getLoginName());
            if(user!=null){
                model.addAttribute("msg","操作失败,该登入名已存在！");
            }else{
                if(myid!=null&&!"".equals(myid)){//myid存在表示编辑操作
                    userInfo.setId(Integer.parseInt(myid));
                    userInfoService.updateUser(userInfo);
                }else{
                    userInfoService.insertUser(userInfo);
                }
                model.addAttribute("msg","操作成功！");
            }
        }catch (Exception e){
            model.addAttribute("msg","操作失败！");
            e.printStackTrace();
        }
        return "redirect:/user/selectAll";
    }
    @RequestMapping("/updateUser")
    public String updateUser(UserInfo userInfo, Model model, String myid){
        try {
            System.out.println(userInfo);
            UserInfo user = userInfoService.selectUserByLoginName(userInfo.getName());
            System.out.println(user);
            if(user ==null){
                model.addAttribute("msg","操作失败,该商品不存在！");
            }else{
                userInfo.setId(user.getId());
                userInfoService.updateUser(userInfo);
            }
            model.addAttribute("msg","操作成功！");
        } catch (Exception e){
            model.addAttribute("msg","操作失败！");
            e.printStackTrace();
        }
        return "redirect:/user/selectAll";
    }
    /**
     * 根据ID获取用户
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("selectUserById")
    @ResponseBody
    public UserInfo selectUserById(int id,Model model){
        UserInfo userInfo = userInfoService.selectUserById(id);
        return userInfo;
    }

    /**
     * 删除用户
     * @param id 用户ID
     * @return
     */
    @RequestMapping("/del")
    @ResponseBody
    public String del(int id){
        try {
            userInfoService.deleteUser(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 获取所有用户
     * @return
     */
    @RequestMapping("/selectAll")
    public String selectAll(Model model, UserInfo userInfo,PageUtil pageP){
        //获取所有数据数量
        int count = userInfoService.selectUserCount();
        PageUtil page = new PageUtil();
        //pageSize默认为10  currentPage默认为1
        page.setPageSize(pageP.getPageSize());
        page.setCurrentPage(pageP.getCurrentPage());
        //mysql中用 --这里用limit a,b 去分页，数据量比较大时不推荐limit
        //a表示起始行，b表示数量，如 limit 0,5 表示查5条数据，从数据库中的第一条查起
        userInfo.setStartRow(page.getStartRow());
        userInfo.setEndRow(page.getEndRow()-page.getStartRow());
        //分页查询数据
        List<UserInfo> userList = userInfoService.selectUserByParams(userInfo);
        //设置所有用户数量  如果有查询条件则以查询结果数量为准，不然为所有数量
        if((userInfo.getName()!=null&&!"".equals(userInfo.getName()))
                ||(userInfo.getLoginName()!=null&&!"".equals(userInfo.getLoginName()))){
            page.setTotalRecord(userList.size());
        }else{
            page.setTotalRecord(count);
        }
        model.addAttribute("page1",page);
        model.addAttribute("userList",userList);
        model.addAttribute("userInfo1",userInfo);
        return "/userManager";
    }

}


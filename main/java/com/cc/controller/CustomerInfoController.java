package com.cc.controller;

import com.cc.model.CustomerInfo;
import com.cc.model.PageUtil;
import com.cc.service.CustomerInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;


@Controller
@RequestMapping("/customer")
public class CustomerInfoController {
    @Autowired
    private CustomerInfoService customerInfoService;

    @RequestMapping("/addCustomer")
    public String addCustomer(CustomerInfo customerInfo,Model model,String myid){
        try {
            CustomerInfo customer = customerInfoService.selectCustomerByName(customerInfo.getName());
            if(customer!=null){
                model.addAttribute("msg","操作失败,该客户已存在！");
            }else{
//                if(myid!=null&&!"".equals(myid)){//myid存在表示编辑操作
//                    customerInfo.setId(Integer.parseInt(myid));
//                    customerInfoService.updateCustomer(customerInfo);
//                }else{
                customerInfoService.insertCustomer(customerInfo);
                //             }
                model.addAttribute("msg","操作成功！");
            }
        }catch (Exception e){
            model.addAttribute("msg","操作失败！");
            e.printStackTrace();
        }
        return "redirect:/customer/selectAll";
    }
    @RequestMapping("/updateCustomer")
    public String updateCustomer(CustomerInfo customerInfo,Model model,String myid){
        try {
            CustomerInfo customer = customerInfoService.selectCustomerByName(customerInfo.getName());

            if(customer ==null){
                model.addAttribute("msg","操作失败,该客户不存在！");
            }else{
                customerInfo.setId(customer.getId());
                customerInfoService.updateCustomer(customerInfo);
            }
            model.addAttribute("msg","操作成功！");
        } catch (Exception e){
            model.addAttribute("msg","操作失败！");
            e.printStackTrace();
        }
        return "redirect:/customer/selectAll";
    }
    /**
     * 根据ID获取
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("selectCustomerById")
    @ResponseBody
    public CustomerInfo selectCustomerById(int id,Model model){
        CustomerInfo customerInfo = customerInfoService.selectCustomerById(id);
        return customerInfo;
    }

    /**
     * 删除
     * @param id ID
     * @return
     */
    @RequestMapping("/del")
    @ResponseBody
    public String del(int id){
        try {
            customerInfoService.deleteCustomer(id);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 获取所有
     * @return
     */
    @RequestMapping("/selectAll")
    public String selectAll(Model model, CustomerInfo customerInfo, PageUtil pageP){

        //获取所有数据数量
        int count = customerInfoService.selectCustomerCount();
        PageUtil page = new PageUtil();
        //pageSize默认为10  currentPage默认为1
        page.setPageSize(pageP.getPageSize());
        page.setCurrentPage(pageP.getCurrentPage());
        //mysql中用 --这里用limit a,b 去分页，数据量比较大时不推荐limit
        //a表示起始行，b表示数量，如 limit 0,5 表示查5条数据，从数据库中的第一条查起
        customerInfo.setStartRow(page.getStartRow());
        customerInfo.setEndRow(page.getEndRow()-page.getStartRow());
        //分页查询数据
        List<CustomerInfo> customerList = customerInfoService.selectCustomerByParams(customerInfo);
        //设置所有用户数量  如果有查询条件则以查询结果数量为准，不然为所有数量
        if((customerInfo.getName()!=null&&!"".equals(customerInfo.getName()))
                ||(customerInfo.getName()!=null&&!"".equals(customerInfo.getName()))){
            page.setTotalRecord(customerList.size());
        }else{
            page.setTotalRecord(count);
        }
        model.addAttribute("page1",page);

        model.addAttribute("customerList",customerList);
        model.addAttribute("customerInfo1",customerInfo);
        return "/customerManager";
    }
}

package com.cc.controller;
import com.cc.model.ItemsInfo;
import com.cc.model.OrderInfo;
import com.cc.model.UserInfo;
import com.cc.service.ItemsInfoService;
import com.cc.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private OrderService orderService;
    @Autowired
    private ItemsInfoService itemsinfoService;

    @RequestMapping("/addOrder")
    public String addOrder(OrderInfo order, Model model){
        boolean flag = true;
        String[] itemsName = order.getItemsName().split(" ");
        String[] itemsNumber = order.getItemsNumber().split(" ");
        int inPrice = 0;
        for(int i = 0; i < itemsName.length; i++)
        {
            List<ItemsInfo> item =  this.itemsinfoService.selectItemsByItemsName(itemsName[i]);
            if(order.getType().equals("retail"))
            {
                for (ItemsInfo a:item)
                {
                    if(a.getLocation().equals("Z"))
                    {
                        a.setNumber(a.getNumber()-Integer.parseInt(itemsNumber[i]));
                        this.itemsinfoService.updateItems(a);
                    }
                }
            }//零售订单数目处理
            inPrice += item.get(0).getInprice();
        }
        order.setInPrice(inPrice);
        if(flag)flag = orderService.insertOrder(order);
        if(flag)
            model.addAttribute("msg","操作成功！");
        else
            model.addAttribute("msg","操作失败！");
        return "redirect:/order/selectAll";
    }
    @RequestMapping("/updateOrder")
    public String updateOrder(OrderInfo orderInfo, Model model){
            OrderInfo order = orderService.selectOrderById(orderInfo.getId());
            order.setTelephone(orderInfo.getTelephone());
            order.setCustomerName(orderInfo.getCustomerName());
            System.err.println(order.getItemsName()+order.getItemsPrice()+order.getId());
            this.orderService.updateOrder(order);
            return "redirect:/order/selectAll";
    }

    /**
     * 根据ID获取
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("selectOrderById")
    @ResponseBody
    public OrderInfo selectOrderById(Integer id,Model model){
        System.out.println(id);
        System.out.println(orderService.selectOrderById(id));
        return orderService.selectOrderById(id);
    }

    /**
     * 处理AJAX对
     * @param id
     * @param model
     * @return
     */
     @RequestMapping("/statechange")
     @ResponseBody
     public OrderInfo Orderstatechange(Integer id,String state,Model model){
         OrderInfo order = orderService.selectOrderById(id);
         if(order.getState().equals("已审核"))
         {
             order.setState(state);
             orderService.updateOrder(order);
         }
         return order;
     }
    /**
     * 删除
     * @param id ID
     * @return
     */
    @RequestMapping("/del")
    public String del(Integer id, Model model){
         boolean flag = orderService.deleteOrder(id);
        if(flag)
            model.addAttribute("msg","操作成功！");
        else
            model.addAttribute("msg","操作失败！");
        return  "redirect:/boss/selectTradeOrder";
    }
    @RequestMapping("/selectOrderByType")
    public String selectOrderByType(String type, Model model){
        List<OrderInfo> orderList = orderService.selectOrderByType(type);
        model.addAttribute("orderList", orderList);
        return "/warehouseOrder";
    }
    @RequestMapping("selectOrderByState")
    public String selectOrderByState(String state, Model model){
        List<OrderInfo> orderList = orderService.selectOrderByState(state);
        model.addAttribute("orderList", orderList);
        return "/orderManager";
    }
    @RequestMapping("selectOrderByParams")
    public String selectOrderByParams(OrderInfo orderInfo, Model model){
        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        return "/orderManager";
    }
    /**
     * 获取所有
     * @return
     */
    @RequestMapping("/selectAll")
    public String selectAll(Model model, OrderInfo orderInfo) {

        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderInfo1", orderInfo);
        return "/orderManager";
    }

}

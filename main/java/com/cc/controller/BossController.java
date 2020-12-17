package com.cc.controller;

import com.cc.model.ItemsInfo;

import com.cc.model.OrderInfo;
import com.cc.model.PageUtil;
import com.cc.service.ItemsInfoService;

import com.cc.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/boss")
public class BossController {
    @Autowired
    private ItemsInfoService itemsInfoService;
    @Autowired
    private OrderService orderService;

    @RequestMapping("/addItems")
    /**
     * 增加新商品
     */
    public String addItems(ItemsInfo item, Model model){
        return "redirect:/boss/selectAll";
    }

    /**
     * 删除
     * @param id ID
     * @return
     */
    @RequestMapping("/del")
    @ResponseBody
    public String del(int id){
        itemsInfoService.deleteItems(id);
        return "redirect:/boss/selectAll";
    }

    @RequestMapping("/updateItems")
    public String updateItems(ItemsInfo item)
    {
        itemsInfoService.updateItems(item);
        return "redirect:/boss/selectAll";
    }
    /**
     * 根据ID获取
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("selectItemsById")
    @ResponseBody
    public ItemsInfo selectItemsById(int id, Model model){
        return itemsInfoService.selectItemsById(id);
    }


    public String selectItemsByLocation(String location, Model model){
        List<ItemsInfo> itemsList = itemsInfoService.selectItemsByLocation(location);
        model.addAttribute("itemsList",itemsList);
        return "/itemsManager";
    }
    /**
     * 获取所有商品
     * @return
     */
    @RequestMapping("/selectAll")
    public String selectAll(Model model, ItemsInfo itemsInfo, PageUtil pageP){

        //获取所有数据数量
        int count = itemsInfoService.selectItemsCount();
        PageUtil page = new PageUtil();
        //pageSize默认为10  currentPage默认为1
        page.setPageSize(pageP.getPageSize());
        page.setCurrentPage(pageP.getCurrentPage());
        //mysql中用 --这里用limit a,b 去分页，数据量比较大时不推荐limit
        //a表示起始行，b表示数量，如 limit 0,5 表示查5条数据，从数据库中的第一条查起
        itemsInfo.setStartRow(page.getStartRow());
        itemsInfo.setEndRow(page.getEndRow()-page.getStartRow());
        //分页查询数据
        List<ItemsInfo> itemsList = itemsInfoService.selectItemsByParams(itemsInfo);
        //设置所有用户数量  如果有查询条件则以查询结果数量为准，不然为所有数量
        if((itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))
                ||(itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))){
            page.setTotalRecord(itemsList.size());
        }else{
            page.setTotalRecord(count);
        }
        model.addAttribute("page1",page);

        model.addAttribute("itemsList",itemsList);
        model.addAttribute("itemsInfo1",itemsInfo);
        return "/itemsManager";
    }
    /**
     * 获取所有批发订单
     * @return
     */
    @RequestMapping("/selectTradeOrder")
    public String selectTradeOrder(Model model, OrderInfo orderInfo) {
        orderInfo.setType("trade");
        List<OrderInfo> tradeList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("tradeList", tradeList);
        model.addAttribute("orderInfo1", orderInfo);
        return "/bossOrder";
    }
}

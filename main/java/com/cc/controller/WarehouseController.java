package com.cc.controller;

import com.cc.dao.wareHouseDao;
import com.cc.model.ItemsInfo;

import com.cc.model.OrderInfo;
import com.cc.service.ItemsInfoService;

import com.cc.service.OrderService;
import com.cc.service.WareHouseService;
import org.apache.ibatis.jdbc.Null;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;


@Controller
@RequestMapping("/warehouse")
public class WarehouseController {
    @Autowired
    private ItemsInfoService itemsInfoService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private HttpServletRequest request;
    @Autowired
    private WareHouseService wareHouseService;
    public String addWareHouse(String wareHouseName){
        wareHouseService.addWareHouse(wareHouseName);
        return "";
    }
    public String getAllWareHouse(Model model){
        List<String> wareHouseList = wareHouseService.getAllWareHouse();
        model.addAttribute("wareHouseList", wareHouseList);
        return "";
    }
    @RequestMapping("/addItems")
    public String addItems(ItemsInfo item, Model model){
        List<ItemsInfo> itemList = itemsInfoService.selectItemsByItemsName(item.getName());
        if(itemList!=null&&!itemList.isEmpty())
        {
            ItemsInfo item1 = itemsInfoService.selectItemsByItemsNameAndLocation(item.getName(),item.getLocation());
            //这好像要进货进已有位置的
            if(item1 != null)
            {
                item1.setNumber(item1.getNumber() + item.getNumber());
                itemsInfoService.updateItems(item1);
            }
            else
            {
                item1 = itemList.get(0);
                item1.setId(null);
                item1.setNumber(item.getNumber());
                item1.setLocation(item.getLocation());
                System.out.println(item1.toString());
                itemsInfoService.insertItems(item1);
            }
            model.addAttribute("msg", "操作成功");
        }
        else   //没有该商品
        {
            model.addAttribute("msg", "没有该商品");
        }
        return "redirect:/warehouse/selectAll";
    }

    /**
     * 商品调度
     * @param myid
     * @param sourceDP
     * @param destDP
     * @param number
     * @param model
     * @return
     */
    @RequestMapping("/dispatchItem")
    public String dispatchItem(int myid, String sourceDP, String destDP, int number,Model model){
        ItemsInfo srcItem = itemsInfoService.selectItemsById(myid);
        if(srcItem.getNumber() >= number) //数量够
        {
            srcItem.setNumber(srcItem.getNumber() - number);

            String itemName = srcItem.getName();
            ItemsInfo dstItem = itemsInfoService.selectItemsByItemsNameAndLocation(itemName,destDP);
            if(dstItem == null){
                dstItem.setName(srcItem.getName());
                dstItem.setLocation(destDP);
                dstItem.setNumber(number);
                itemsInfoService.insertItems(dstItem);
            }
            else {
                dstItem.setNumber(dstItem.getNumber() + number);
                itemsInfoService.updateItems(dstItem);
            }updateItems(srcItem);
            model.addAttribute("msg", "调度成功");
        }
        else   model.addAttribute("msg", "数量不够");
        return "redirect:/warehouse/selectAll";
    }
    @RequestMapping("/getOrderItemInfo")
    @ResponseBody
    public List<List<String> > getOrderItemInfo(int id){
        OrderInfo order = orderService.selectOrderById(id);
        List<String> itemsName = Arrays.asList(order.getItemsName().split(" "));
        System.out.println(itemsName.toString());
        List<String> itemsNumber = Arrays.asList(order.getItemsNumber().split(" "));
        List<List<String> > wareHouses = new ArrayList<>();
        wareHouses.add(itemsName);
        wareHouses.add(itemsNumber);
        List<String> isEnough = new ArrayList<>();
        for(int i = 0; i < itemsName.size(); i++){
            List<ItemsInfo> items = itemsInfoService.selectItemsByItemsName(itemsName.get(i));
            List<String> lst = new ArrayList<>();
            int totalNumber = 0;
            for(int j = 0; j < items.size(); j++){
                lst.add(items.get(j).getLocation());
                totalNumber += items.get(j).getNumber();
            }
            if(Integer.parseInt(itemsNumber.get(i)) > totalNumber)
                isEnough.add("缺货");
            else isEnough.add("有货");
            Collections.sort(lst);
            wareHouses.add(lst);
        }
        wareHouses.add(isEnough);
        return wareHouses;
    }
    @RequestMapping("/distributeItems")
    public String distributeItems(String distribution, Model model){
        int orderId = Integer.parseInt(distribution.split("=")[0]);
        String [] itemDistributionInfo = distribution.split("=")[1].split("-"); //获取订单每一个商品的分配信息
        boolean isEnough = true; //是否缺货
        List<List<ItemsInfo> >  items = new ArrayList<>();
        for(int i = 0; i < itemDistributionInfo.length && isEnough; i++)
        {
            String itemName = itemDistributionInfo[i].split(":")[0]; //获取商品名字
            String [] numbers = itemDistributionInfo[i].split(":")[1].split(" "); //获取分配各个仓库数量
            items.add(itemsInfoService.selectItemsByItemsName(itemName));//获取该商品在各个仓库的信息
            for(int j = 0; j < items.get(i).size(); j++) //更新仓库商品信息
            {
                if(items.get(i).get(j).getNumber() >= Integer.parseInt(numbers[j]))//该仓库商品够
                {
                    items.get(i).get(j).setNumber(items.get(i).get(j).getNumber() - Integer.parseInt(numbers[j]));
                }
                else
                {
                    isEnough = false; //该仓库货不够 分配方案不行
                    model.addAttribute("msg", "商品:" + itemName + "缺货");
                    break;
                }
            }
        }
        if(isEnough){
            for(int i = 0; i < items.size(); i++)   //分配方案可行 更新数据库
            {
                for(int j = 0; j < items.get(i).size(); j++){
                    itemsInfoService.updateItems(items.get(i).get(j));
                }
            }
            OrderInfo order = orderService.selectOrderById(orderId);
            order.setState("已审核"); //更新订单状态
            orderService.updateOrder(order);
        }
        OrderInfo orderInfo = new OrderInfo();
        orderInfo.setState("未审核");
        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        return  "/warehouseOrder";
    }
    @RequestMapping("/updateItems")
    public String updateItems(ItemsInfo item)
    {
        itemsInfoService.updateItems(item);
        return "redirect:/warehouse/selectAll";
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
        ItemsInfo itemsInfo = itemsInfoService.selectItemsById(id);
        return itemsInfo;
    }


    public String selectItemsByLocation(String location, Model model){
        List<ItemsInfo> itemsList = itemsInfoService.selectItemsByLocation(location);
        model.addAttribute("itemsList",itemsList);
        return "/warehouse";
    }
    /**
     * 获取所有
     * @return
     */
    @RequestMapping("/selectAll")
    public String selectAll(Model model, ItemsInfo itemsInfo){
        /*
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
      */  //分页查询数据
        List<ItemsInfo> itemsList = itemsInfoService.selectItemsByParams(itemsInfo);
        //设置所有用户数量  如果有查询条件则以查询结果数量为准，不然为所有数量
     /*   if((itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))
                ||(itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))){
            page.setTotalRecord(itemsList.size());
        }else{
            page.setTotalRecord(count);
        }
        model.addAttribute("page1",page);
      */
        Map<String,Integer> Numberofnames = new HashMap<>();
        for(ItemsInfo i:itemsList)
        {
            if(Numberofnames.containsKey(i.getName()))
            {
                Numberofnames.put(i.getName(),Numberofnames.get(i.getName())+i.getNumber());
            }
            else  Numberofnames.put(i.getName(),i.getNumber());
        }//这里是用来计算总库存的。
        this.request.getSession().setAttribute("Numberofnames",Numberofnames);
        model.addAttribute("itemsList",itemsList);
        model.addAttribute("itemsInfo1",itemsInfo);
        return "/warehouse";
    }

    /**
     * 获取所有批发订单
     * @return
     */
    @RequestMapping("/selectTradeOrder")
    public String selectTradeOrder(Model model, OrderInfo orderInfo) {
        orderInfo.setType("trade");
        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderInfo1", orderInfo);
        return "/warehouseOrder";
    }
    @RequestMapping("/selectOrderByState")
    public String selectOrderByState(Model model){
        OrderInfo orderInfo = new OrderInfo();
        orderInfo.setState("待分配");
        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        return "/warehouseOrder";
    }
    @RequestMapping("selectOrderByParams")
    public String selectOrderByParams(OrderInfo orderInfo, Model model){
        List<OrderInfo> orderList = orderService.selectOrdersByParams(orderInfo);
        model.addAttribute("orderList", orderList);
        return  "/warehouseOrder";
    }
    /**
     * 仓库筛选
     * @return
     */
    @RequestMapping("/selectWarehouse")
    public String selectWarehouseAll(Model model,String warehouse){

        List<ItemsInfo> itemsList = itemsInfoService.selectAll();
        for(int counter = 0;counter<itemsList.size();counter++)
        {
            if(!itemsList.get(counter).getLocation().equals(warehouse)) {
                itemsList.remove(itemsList.get(counter));
                counter--;
            }
        }
        model.addAttribute("itemsList",itemsList);
        return "/warehouse";
    }
}

package com.cc.controller;

import com.cc.model.ItemsInfo;
import com.cc.model.UserInfo;
import com.cc.service.ItemsInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedList;
import java.util.List;


@Controller
@RequestMapping("/items")
public class itemsController {
    @Autowired
    private ItemsInfoService itemsInfoService;
    @Autowired
    private  HttpServletRequest request;
    @RequestMapping("/addItems")
    public String addItems(ItemsInfo itemsInfo,Model model){
            System.out.println("hello");
            List<ItemsInfo> items = itemsInfoService.selectItemsByItemsName(itemsInfo.getName());
            if(items!=null&&!items.isEmpty()){
                model.addAttribute("msg","操作失败,该商品已存在！");
            }else{
                    itemsInfo.setLocation("Z");//新商品初始放入门店
                    itemsInfoService.insertItems(itemsInfo);
   //            }
                model.addAttribute("msg","操作成功！");
            }

        return "redirect:/items/selectAll";
    }
    @RequestMapping("/updateItems")
    public String updateItems(ItemsInfo itemsInfo,Model model,String myid){
        try {
            List<ItemsInfo> items = itemsInfoService.selectItemsByItemsName(itemsInfo.getName());
            if(items != null){
                for(ItemsInfo item : items){
                    item.setPrice(itemsInfo.getPrice());
                    itemsInfoService.updateItems(item);
                }
                model.addAttribute("msg","操作成功！");
            }
            else model.addAttribute("msg","操作失败！");
        } catch (Exception e){
            model.addAttribute("msg","操作失败！");
            e.printStackTrace();
        }
        return "redirect:/items/selectAll";
    }
    /**
     * 根据ID获取
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("selectItemsById")
    @ResponseBody
    public ItemsInfo selectItemsById(int id,Model model){
        ItemsInfo itemsInfo = itemsInfoService.selectItemsById(id);
        return itemsInfo;
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
            itemsInfoService.deleteItems(id);
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

        //设置所有用户数量  如果有查询条件则以查询结果数量为准，不然为所有数量
     /*   if((itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))
                ||(itemsInfo.getName()!=null&&!"".equals(itemsInfo.getName()))){
            page.setTotalRecord(itemsList.size());
        }else{
            page.setTotalRecord(count);
        }
        model.addAttribute("page1",page);
      */

        List<ItemsInfo> itemsList = itemsInfoService.selectItemsByParams(itemsInfo);
        List<ItemsInfo> removeList = new LinkedList<>();
        if (this.request.getSession().getAttribute("userInfo")!=null&&((UserInfo)this.request.getSession().getAttribute("userInfo")).getIdentity().equals("sales"))
        {
            for(ItemsInfo a:itemsList)
            {
                 if(!a.getLocation().equals("Z"))
                 {
                     removeList.add(a);
                 }
            }
            itemsList.removeAll(removeList);
        }
        model.addAttribute("itemsList",itemsList);
        model.addAttribute("itemsInfo1",itemsInfo);
        return "/itemsManager";
    }
}

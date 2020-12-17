package com.cc.service.Impl;

import com.cc.dao.ItemsInfoDao;
import com.cc.dao.OrderDao;
import com.cc.dao.OrderitemsDao;
import com.cc.model.ItemsInfo;
import com.cc.model.OrderInfo;
import com.cc.model.Orderitem;
import com.cc.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service("orderService")
public class OrderServiceImpl implements OrderService {
    @Autowired
    private OrderDao orderDao;
    @Autowired
    private ItemsInfoDao itemsInfoDao;
    @Autowired
    private OrderitemsDao orderitemsDao;
    @Override
    public boolean insertOrder(OrderInfo order) {
        //OrderInfo order1 = orderDao.selectOrderById(order.getId());
        //if(order1 != null) { //订单已存在
            //return false; //添加失败
        //}
        orderDao.addOrder(order); //添加订单
        String itemname[] = order.getItemsName().split(" ");
        String itemnum[] = order.getItemsNumber().split(" ");
        for(int counter = 0;counter<itemname.length;counter++)
        {
            this.orderitemsDao.addOrderitem(new Orderitem(order.getId(),itemsInfoDao.selectItemsByItemsName(itemname[counter]).get(0).getId(),Integer.parseInt(itemnum[counter])));
        }
        return true; //添加成功
    }

    public boolean deleteOrder(Integer id) {
        OrderInfo order1 = orderDao.selectOrderById(id).updatedata(this.orderitemsDao,this.itemsInfoDao);
        if(order1 != null) { //订单存在
            String[] itemsName = order1.getItemsName().split(" ");
            String[] itemsNumber = order1.getItemsNumber().split(" ");
            for(int i = 0 ; i < itemsName.length; i++){
                List<ItemsInfo> items = itemsInfoDao.selectItemsByItemsName(itemsName[i]);
                if(items.size()==0)continue;
                items.get(0).setNumber(items.get(0).getNumber() + Integer.parseInt(itemsNumber[i]));
                itemsInfoDao.updateItems(items.get(0));
            }
            orderDao.deleteOrder(id);
            this.orderitemsDao.deleteOrderitem(order1.getId());
            return true; //删除成功
        }
        return false; //订单不存在 删除失败
    }

    @Override
    public boolean updateOrder(OrderInfo order) {
        OrderInfo order1 = orderDao.selectOrderById(order.getId()).updatedata(orderitemsDao,itemsInfoDao);
        if(order1 == null) { //订单不存在
            return false; //更新失败
        }
        orderDao.updateOrder(order);
        this.orderitemsDao.deleteOrderitem(order1.getId());
        String itemname[] = order.getItemsName().split(" ");
        String itemnum[] = order.getItemsNumber().split(" ");
        for(int counter = 0;counter<itemname.length;counter++)
        {
            this.orderitemsDao.addOrderitem(new Orderitem(order1.getId(),itemsInfoDao.selectItemsByItemsName(itemname[counter]).get(0).getId(),Integer.parseInt(itemnum[counter])));
        }
        return true; //更新·成功
    }

    @Override
    public OrderInfo selectOrderById(Integer id) {
        return orderDao.selectOrderById(id).updatedata(orderitemsDao,itemsInfoDao);
    }

    @Override
    public List<OrderInfo> selectOrderByType(String type) {
        List<OrderInfo> s=  orderDao.selectOrderByType(type);
        for (OrderInfo o:s)
        {
            o.updatedata(orderitemsDao,itemsInfoDao);
        }
        return s;
    }

    @Override
    public List<OrderInfo> selectOrderByState(String state) {
        List<OrderInfo> s= orderDao.selectOrderByState(state);
        for (OrderInfo o:s)
        {
            o.updatedata(orderitemsDao,itemsInfoDao);
        }
        return s;
    }

    @Override
    public List<OrderInfo> selectAll() {
        List<OrderInfo> s= orderDao.selectAll();
        for (OrderInfo o:s)
        {
            o.updatedata(orderitemsDao,itemsInfoDao);
        }
        System.out.println("使用");
        return s;
    }
    public OrderInfo selectOrderByCustomerName(String Name) {

        return orderDao.selectOrderByCustomerName(Name).updatedata(orderitemsDao,itemsInfoDao);
    }
    @Override
    public List<OrderInfo> selectOrdersByParams(OrderInfo orderInfo) {
        List<OrderInfo> s= orderDao.selectOrderByParams(orderInfo);
        for (OrderInfo o:s)
        {
            o.updatedata(orderitemsDao,itemsInfoDao);
        }
        System.out.println("使用");
        return s;
    }
}

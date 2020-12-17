package com.cc.service.Impl;

import com.cc.dao.ItemsInfoDao;
import com.cc.dao.OrderitemsDao;
import com.cc.model.Orderitem;
import com.cc.service.OrderitemsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
@Service("OrderitemsService")
public class OrderitemsServiceimpl implements OrderitemsService {
    @Resource
    private OrderitemsDao orderitemsDao;
    @Override
    public void addOrderitem(Orderitem oi) {
        orderitemsDao.addOrderitem(oi);
    }
    @Override
    public List<Orderitem> getItemidByOrderid(Integer orderid) {
        return orderitemsDao.getItemidByOrderid(orderid);
    }
}

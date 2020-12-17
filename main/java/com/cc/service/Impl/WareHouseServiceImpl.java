package com.cc.service.Impl;

import com.cc.dao.wareHouseDao;
import com.cc.service.WareHouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WareHouseServiceImpl implements WareHouseService {
    @Autowired
    private com.cc.dao.wareHouseDao wareHouseDao;

    @Override
    public boolean addWareHouse(String wareHouseName) {
         wareHouseDao.addWareHouse(wareHouseName);
         return true;
    }

    @Override
    public List<String> getAllWareHouse() {
        return wareHouseDao.getAllWareHouse();
    }
}

package com.cc.dao;

import java.util.List;

public interface wareHouseDao {
    void addWareHouse(String wareHouseName);
    List<String> getAllWareHouse();
}

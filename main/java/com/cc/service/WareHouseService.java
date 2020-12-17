package com.cc.service;

import java.util.List;

public interface WareHouseService {
    boolean addWareHouse(String wareHouseName);
    List<String> getAllWareHouse();
}

package com.cc.model;

import javax.persistence.criteria.CriteriaBuilder;

public class ItemsInfo {
    private Integer id;
    private String name;
    private Integer price;
    private int number;
    private String location;
    private Integer tradeprice;
    private Integer inprice;
    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }
    private int startRow;
    private int endRow;
    public Integer getTradeprice() {
        return tradeprice;
    }

    public void setTradeprice(Integer tradeprice) {
        this.tradeprice = tradeprice;
    }

    public Integer getInprice() {
        return inprice;
    }

    public void setInprice(Integer inprice) {
        this.inprice = inprice;
    }
    public int getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getPrice() {
        return price;
    }
    public void setPrice(int price) {
        this.price = price;
    }
    public int getNumber() {
        return number;
    }
    public void setNumber(int number) {
        this.number = number;
    }
    public int getStartRow() {
        return startRow;
    }
    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }
    public int getEndRow() {
        return endRow;
    }
    public void setEndRow(int endRow) {
        this.endRow = endRow;
    }

    @Override
    public String toString() {
        return "ItemsInfo{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", number=" + number +
                ", location='" + location + '\'' +
                ", tradeprice=" + tradeprice +
                ", inprice=" + inprice +
                ", startRow=" + startRow +
                ", endRow=" + endRow +
                '}';
    }
}

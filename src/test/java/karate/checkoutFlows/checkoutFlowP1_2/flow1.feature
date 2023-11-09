
@Sanity
Feature: Item without Inventory
  Scenario: Add item to the cart without Inventory

    * def product  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(Non_InventoryItemId)'}
    * def ItemId1 = product.response.variants[0].itemId
    * def ItemId2 = product.response.variants[1].itemId
    * def ItemId1Attributes = product.response.variants[0].attributes
    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId2)'}
    * def price1 = price.response.data[0].offer.price.base
    * def price2 = price.response.data[1].offer.price.base
    * def sku1 = product.response.variants[0].sku
    * def sku2 = product.response.variants[1].sku
    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@ForNon_InventoryItem') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@ForNon_InventoryItem') {sku : '#(sku2)'}
    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingNon_InventoryItem') {ItemId: '#(ItemId1)', amount: '#(price1)' , ItemAttributes:'#(ItemId1Attributes)'}


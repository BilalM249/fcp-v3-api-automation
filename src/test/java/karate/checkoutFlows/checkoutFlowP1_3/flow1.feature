@Sanity
Feature: Item without Price
  Scenario: Add item to the cart without Price
    * def product  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(Non_PriceItemId)'}
    * def ItemAttributes = product.response.attributes
    * print "ITEM ATTRIBUTES: " + ItemAttributes
    * def ItemId = product.response.itemId
    * def price  = call read('classpath:karate/core/price/price.feature@ForNon_PriceItem') {ItemId: '#(ItemId)'}
    * def sku = product.response.sku

    * def inventoryForItem  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingNon_PriceItem') {ItemId: '#(ItemId)', amount: '#(priceForItem)',  ItemAttributes:'#(ItemAttributes)'}

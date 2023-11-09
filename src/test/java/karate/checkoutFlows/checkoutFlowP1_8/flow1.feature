@Sanity
Feature: Checkout with Variant + Non-Variant Product with multi-tier coupon.

  Scenario: Checkout with Variant + Non-Variant Product with multi-tier coupon.
    * def variantProduct  = call read('classpath:karate/core/pim/pim.feature@ForVariantItem') {ItemId : '#(variant_itemId)'}
    * def ItemId1 = variantProduct.response.variants[0].itemId
    * def ItemId2 = variantProduct.response.variants[1].itemId
    * def ItemId1Attributes = variantProduct.response.variants[0].attributes
    * def ItemId2Attributes = variantProduct.response.variants[1].attributes
    * def sku1 = variantProduct.response.variants[0].sku
    * def sku2 = variantProduct.response.variants[1].sku

    * def nonVariantProduct  = call read('classpath:karate/core/pim/pim.feature@ForNonVariantItem') {ItemId : '#(multitier_coupon_applicable_non_variant_itemId)'}
    * def ItemAttributes = nonVariantProduct.response.attributes
    * def ItemId = nonVariantProduct.response.itemId
    * def sku =  nonVariantProduct.response.sku

    * def price  = call read('classpath:karate/core/price/price.feature@PriceFor2Items') {ItemId1: '#(ItemId1)', ItemId2: '#(ItemId)'}
    * def priceForItem1 = price.response.data[0].offer.price.base
    * def priceForItem2 = price.response.data[1].offer.price.base


    * def inventoryForItem1  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku1)'}
    * def inventoryForItem2  = call read('classpath:karate/core/inventory/inventory.feature@InventoryConfigured') {sku : '#(sku)'}

    * def cart = call read('classpath:karate/core/cart/addToCart.feature@AddingMultipleItemToCart') {ItemId1: '#(ItemId1)' , amount1: '#(priceForItem1)' ,  ItemAttributes1:'#(ItemId1Attributes)', ItemId2: '#(ItemId)' , amount2: '#(priceForItem2)' , ItemAttributes2:'#(ItemAttributes) '}
    * def lineItemId1 = cart.response.lineItems[0].id
    * def position1 = cart.response.lineItems[0].position
    * def lineItemId2 = cart.response.lineItems[1].id
    * def position2 = cart.response.lineItems[1].position

    * def shippingDetails = call read('classpath:karate/core/oms/GetShippingByID.feature') {shippingId: '#(shipMethodId)'}
    * def shippingId = shippingDetails.response.shippingMethodId
    * def shippingCost = shippingDetails.response.cost
    * def cartId = cart.response.id
    * def createShipTo = call read('classpath:karate/core/cart/createShipTo.feature') {cartId: '#(cartId)', shippingMethodId: '#(shippingId)', shippingCost: '#(shippingCost)' }

    * def shipToId = createShipTo.response.id

    * def applyCoupon = call read('classpath:karate/core/cart/applyCoupon.feature@ApplyingMultiTierCoupon') {cartId: '#(cartId)', couponCode : '#(Non_Variant_Multitier_Quantity_Coupon)'}

    * def cartQuantity = call read('classpath:karate/core/cart/updateQuantity.feature@UpdateQtyForMultiLineItemAndMultiTierQuantityCoupon') {lineItemId: '#(lineItemId1)', position: '#(position1)' ,productId: '#(ItemId)', cartId: '#(cartId)', Quantity: '2' }

    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId1)'}
    * def addShipToCart = call read('classpath:karate/core/cart/addShippingToCart.feature@SingleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', ItemId: '#(lineItemId2)'}

    * def getCart = call read('classpath:karate/core/cart/getCart.feature@GetCartWithMultiLineItem') {cartID: '#(cartId)' }

    * def cartAmount = getCart.response.totalAmount - createShipTo.response.shippingCost

    * def checkout = call read('classpath:karate/core/checkout/checkout.feature@CheckoutMultipleLineItem') {cartId: '#(cartId)', shipToId: '#(shipToId)', shippingCost: '#(shippingCost)', cartTotal: '#(cartAmount)'}
    * def orderId = checkout.response.orderId
    * def getOrder = call read('classpath:karate/core/oms/getOrderById.feature@GetOrderForMultiLineItem') {orderId : '#(orderId)'}
    Then print getOrder
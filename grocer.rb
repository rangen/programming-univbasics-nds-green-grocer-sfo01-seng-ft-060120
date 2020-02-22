def find_item_by_name_in_collection(name, collection)
  index = 0
  while index < collection.length
    if collection[index][:item] == name
      return collection[index]
    end
    index += 1
  end
  nil
end

def consolidate_cart(cart)
  consolidated_cart = []
  index = 0
  added_items = []  #this array will keep track of if an item is already conslidated to avoid duplicates in the consolidated cart

  while index < cart.length
    current_item = cart[index]
    if !added_items.index(current_item[:item])              #will result in true when item is not included in added_items
      added_items << current_item[:item]                    #signifies we have processed the first instance of a cart item
      current_item[:count] = count_num_in_cart(current_item[:item], cart) #add a key to existing item hash of total num in cart
      consolidated_cart << current_item                     #finally, add the consolidated item to the new cart
    end
    index += 1
  end
  consolidated_cart
end

def count_num_in_cart(item_name, cart)
  index = 0
  count = 0

  while index < cart.length
     count += 1 if (cart[index][:item] == item_name)
     index += 1
  end
  count
end

def apply_coupons(cart, coupons)
  coupon_index = 0
  index = 0


  while coupon_index < coupons.length
    #attempt to apply coupons[index]
    if can_coupon_be_applied?(cart, coupons[coupon_index])
              #apply coupon
              #first, remove regular priced item count; also, when instance found, record clearance boolean
              item_to_discount = coupons[coupon_index][:item]
              num_to_discount = coupons[coupon_index][:num]

              while index < cart.length #find item in cart and decrement regular priced items
                            if cart[index][:item] == item_to_discount
                                      cart[index][:count] -= num_to_discount #decrement regular priced items
                                      is_item_on_clearance = cart[index][:clearance]  #record clearance status to preserve in discounted item
                            end
                            index += 1
              end
              #add new, discounted item to cart
              discounted_item_name = item_to_discount + " W/COUPON"
              num_discounted_items = coupons[coupon_index][:num]
              discounted_item_price = (coupons[coupon_index][:cost] / num_discounted_items)

              newHash = {:item => discounted_item_name, :price => discounted_item_price, :clearance => is_item_on_clearance, :count => num_discounted_items}
              cart << newHash
    end
    index = 0
    coupon_index += 1
  end
  cart
end

def can_coupon_be_applied?(cart, coupon)
  index = 0

  while index < cart.length
    puts "is #{index} < #{cart.length}"
    return true if (coupon[:item] == cart[index][:item] && cart[index][:count] >= coupon[:num])
    index += 1
  end
  false
end

def apply_clearance(cart)
  index = 0
  while index < cart.length
    cart[index][:price] *= 0.8 if cart[index][:clearance]
    index += 1
  end
  cart
end

def total_cart(cart)
  index = 0
  total = 0

  while index < cart.length
    total += cart[index][:price] * cart[index][:count]
    index += 1
  end
  total
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_cart(cart)
end

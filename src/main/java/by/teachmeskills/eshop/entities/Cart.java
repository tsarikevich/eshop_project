package by.teachmeskills.eshop.entities;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Getter
@Setter
@EqualsAndHashCode
public class Cart {
    private Map<Product, Integer> products;
    private BigDecimal totalCost = BigDecimal.ZERO;

    public Cart() {
        this.products = new LinkedHashMap<>();
    }

    public void addProduct(Product product) {
        if (products.containsKey(product)) {
            products.put(product, products.get(product) + 1);
        } else {
            products.put(product, 1);
        }
        BigDecimal price = product.getPrice();
        totalCost = totalCost.add(price);
    }

    public void deleteOneProduct(Product product) {
        if (products.size() > 0) {
            if (products.get(product) > 1) {
                products.put(product, products.get(product) - 1);
            } else {
                products.remove(product);
            }
            BigDecimal price = product.getPrice();
            totalCost = totalCost.subtract(price);
        }
    }

    public void deleteProducts(Product product) {
        if (Optional.ofNullable(product).isPresent() && products.size() > 0) {
            String quantityProducts = String.valueOf(products.get(product));
            BigDecimal priceProducts = product.getPrice().multiply(new BigDecimal(quantityProducts));
            totalCost = totalCost.subtract(priceProducts);
            products.remove(product);
        }
    }

    public List<Product> getListProducts() {
        return new ArrayList<>(products.keySet());
    }

    public List<Integer> getListNumbers() {
        return new ArrayList<>(products.values());
    }

    public BigDecimal getTotalPrice() {
        return totalCost;
    }

    public void clear() {
        products.clear();
        totalCost = BigDecimal.ZERO;
    }
}

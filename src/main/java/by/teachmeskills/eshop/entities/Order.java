package by.teachmeskills.eshop.entities;

import com.opencsv.bean.CsvBindByName;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.apache.commons.lang3.StringUtils;

import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MapKeyJoinColumn;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@SuperBuilder
@NoArgsConstructor
@Getter
@Setter
@Entity
@EqualsAndHashCode(callSuper = true, exclude = "user")
@Table(name = "orders")
public class Order extends BaseEntity {
    @CsvBindByName
    @Column(name = "price")
    private BigDecimal price;

    @Column(name = "date")
    @CsvBindByName
    private LocalDateTime date;

    @ManyToOne(targetEntity = User.class)
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

    @CsvBindByName
    @ElementCollection(fetch = FetchType.EAGER)
    @MapKeyJoinColumn(table = "order_products", name = "product_id")
    @Column(name = "quantity", nullable = false)
    private Map<Product, Integer> products = new HashMap<>();

    public Map<Product, Integer> getProducts() {
        return Collections.unmodifiableMap(products);
    }

    public void addProducts(Product product, int quantity) {
        products.merge(product, quantity, Integer::sum);
    }

    public void removeItem(Product product) {
        products.computeIfPresent(product, (k, v) -> v > 1 ? v - 1 : null);
    }

    @Override
    public String toString() {
        return "Order{" +
                "price=" + price +
                ", date=" + date +
                ", products=" + StringUtils.join(getProducts()) +
                '}';
    }
}

package by.teachmeskills.eshop.entities;

import com.opencsv.bean.CsvBindByName;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.math.BigDecimal;
import java.util.List;

@SuperBuilder
@NoArgsConstructor
@ToString
@Getter
@Setter
@Entity
@EqualsAndHashCode(callSuper = true, exclude = {"category", "images"})
@Table(name = "products")
public class Product extends BaseEntity {
    @CsvBindByName
    @Column(name = "name", unique = true)
    private String name;

    @CsvBindByName
    @Column(name = "description", columnDefinition = "varchar(400)")
    private String description;

    @CsvBindByName
    @Column(name = "price")
    private BigDecimal price;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    @ToString.Exclude
    private Category category;

    @OneToMany(mappedBy = "product", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    List<Image> images;
}

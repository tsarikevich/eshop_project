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
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
@Entity
@ToString
@EqualsAndHashCode(callSuper = true, exclude = {"products", "image"})
@SuperBuilder
@Table(name = "categories")
public class Category extends BaseEntity {
    @CsvBindByName
    @Column(name = "name", unique = true)
    private String name;

    @CsvBindByName
    @Column(name = "rating")
    private double rating;

    @OneToMany(mappedBy = "category", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    private List<Product> products;

    @OneToOne(mappedBy = "category", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @ToString.Exclude
    private Image image;
}

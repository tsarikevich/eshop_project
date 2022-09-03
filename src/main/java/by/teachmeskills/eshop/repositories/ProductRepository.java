package by.teachmeskills.eshop.repositories;

import by.teachmeskills.eshop.entities.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer>, JpaSpecificationExecutor<Product> {

    List<Product> getProductsByCategoryId(int id);

    Page<Product> findAllByCategoryId(int id, Pageable pageable);
}

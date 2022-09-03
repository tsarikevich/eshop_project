package by.teachmeskills.eshop.repositories;

import by.teachmeskills.eshop.entities.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    @Modifying
    @Query("delete from Order where id=?1")
    void deleteById(int id);

}

package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.User;
import org.springframework.web.servlet.ModelAndView;

import java.io.Writer;

public interface UserService extends BaseService<User> {

    ModelAndView registration(User user, int year, int month, int day);

    ModelAndView showProfile();

    void writeProfileToCsv(Writer writer);

    void writeOrderToCsv(int orderId, Writer writer);
}

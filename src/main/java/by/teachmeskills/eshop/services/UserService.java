package by.teachmeskills.eshop.services;

import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.exceptions.UserException;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;

public interface UserService extends BaseService<User> {

    ModelAndView registration(User user, int year, int month, int day);

    ModelAndView showProfile();

    ModelAndView addUserOnUsersPage(User user, String role) throws UserException;

    ModelAndView getUsersDataForUsersPage();

    ModelAndView updateUserOnUsersPage(User user, String role) throws UserException;

    ModelAndView deleteUserFromUsersPage(int id);

    void writeProfileToCsv(HttpServletResponse response);

    void writeOrderToCsv(int orderId, HttpServletResponse response);

    String getAuthorizationUserLoginOrDefault();
}

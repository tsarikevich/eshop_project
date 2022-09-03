package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.exceptions.UserException;
import by.teachmeskills.eshop.services.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import static by.teachmeskills.eshop.utils.EshopConstants.ROLE;

@RestController
@RequestMapping("/users")
public class UserController {
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public ModelAndView getUsersPage(){
        return userService.getUsersDataForUsersPage();
    }

    @PostMapping("/edit")
    public ModelAndView editUser(@ModelAttribute User user, @RequestParam(ROLE) String role) throws UserException {
        return userService.updateUserOnUsersPage(user,role);
    }

    @PostMapping("/delete/{id}")
    public ModelAndView deleteUser(@PathVariable int id){
        return userService.deleteUserFromUsersPage(id);
    }

    @PostMapping("/add")
    public ModelAndView addUser(@ModelAttribute User user, @RequestParam(ROLE) String role) throws UserException {
        return userService.addUserOnUsersPage(user,role);
    }
}

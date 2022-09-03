package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.services.UserService;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import static by.teachmeskills.eshop.utils.EshopConstants.BIRTH_DAY;
import static by.teachmeskills.eshop.utils.EshopConstants.BIRTH_MONTH;
import static by.teachmeskills.eshop.utils.EshopConstants.BIRTH_YEAR;
import static by.teachmeskills.eshop.utils.EshopConstants.CHECK_NEW_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.REGISTER_USER;
import static by.teachmeskills.eshop.utils.PagesPathEnum.REGISTRATION_PAGE;


@RestController
@RequestMapping("/registration")
public class RegistrationController {
    private final UserService userService;

    public RegistrationController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public ModelAndView openRegistrationPage() {
        ModelMap model = new ModelMap();
        model.addAttribute(CHECK_NEW_USER, true);
        return new ModelAndView(REGISTRATION_PAGE.getPath(), model);
    }

    @PostMapping
    public ModelAndView registration(@ModelAttribute(REGISTER_USER) User user, @RequestParam(BIRTH_DAY) int day,
                                     @RequestParam(BIRTH_MONTH) int month, @RequestParam(BIRTH_YEAR) int year) {
        return userService.registration(user, year, month, day);
    }
}
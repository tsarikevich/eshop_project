package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.services.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;

import static by.teachmeskills.eshop.utils.EshopConstants.ORDER_ID;

@RestController
@RequestMapping("/profile")
public class ProfileController {
    private final UserService userService;

    public ProfileController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public ModelAndView getProfilePage() {
        return userService.showProfile();
    }

    @GetMapping("/download")
    public void downloadUserCsvFile(HttpServletResponse response){
        userService.writeProfileToCsv(response);
    }

    @GetMapping("order/download")
    public void downloadOrderCsvFile(HttpServletResponse response, @RequestParam(ORDER_ID) int orderId){
        userService.writeOrderToCsv(orderId, response);
    }
}

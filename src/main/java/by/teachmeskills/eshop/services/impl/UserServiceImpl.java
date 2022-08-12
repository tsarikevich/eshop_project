package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.entities.Image;
import by.teachmeskills.eshop.entities.Order;
import by.teachmeskills.eshop.entities.Role;
import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.repositories.ImageRepository;
import by.teachmeskills.eshop.repositories.OrderRepository;
import by.teachmeskills.eshop.repositories.RoleRepository;
import by.teachmeskills.eshop.repositories.UserRepository;
import by.teachmeskills.eshop.services.UserService;
import com.opencsv.CSVWriter;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

import java.io.Writer;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static by.teachmeskills.eshop.utils.EshopConstants.ID_ROLE_USER;
import static by.teachmeskills.eshop.utils.PagesPathEnum.PROFILE_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.REGISTRATION_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.SIGN_IN_PAGE;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ACTIVE_BUTTON_NAV_MENU;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CHECK_NEW_USER;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ORDERS;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ORDER_PRODUCTS_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.USER;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.USER_LOGIN;

@Service
@Log4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final ImageRepository imageRepository;
    private final OrderRepository orderRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;

    public UserServiceImpl(UserRepository userRepository, ImageRepository imageRepository, OrderRepository orderRepository, PasswordEncoder passwordEncoder, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.imageRepository = imageRepository;
        this.orderRepository = orderRepository;
        this.passwordEncoder = passwordEncoder;
        this.roleRepository = roleRepository;
    }

    @Override
    public User create(User entity) {
        entity.setPassword(passwordEncoder.encode(entity.getPassword()));
        Optional<Role> role = roleRepository.findById(ID_ROLE_USER);
        Set<Role> roles = new HashSet<>();
        roles.add(role.get());
        entity.setRoles(roles);
        return userRepository.save(entity);
    }

    @Override
    public List<User> read() {
        return userRepository.findAll();
    }

    @Override
    public User update(User entity) {
        Optional<User> user = userRepository.findById(entity.getId());
        if (user.isPresent()) {
            return userRepository.save(entity);
        }
        log.error("User doesn't exist");
        return null;
    }

    @Override
    public void delete(int id) {
        userRepository.deleteById(id);
    }

    @Override
    public ModelAndView registration(User user, int year, int month, int day) {
        ModelAndView modelAndView = new ModelAndView();
        if (Optional.ofNullable(user).isPresent()
                && Optional.ofNullable(user.getLogin()).isPresent()
                && Optional.ofNullable(user.getName()).isPresent()
                && Optional.ofNullable(user.getSurname()).isPresent()
                && Optional.ofNullable(user.getEmail()).isPresent()
                && Optional.ofNullable(user.getPassword()).isPresent()) {
            LocalDate birthDate = LocalDate.of(year, month, day);
            user.setBirthDate(birthDate);
            if (checkExistUserInDB(user)) {
                ModelMap modelMap = new ModelMap();
                modelMap.addAttribute(CHECK_NEW_USER.getValue(), false);
                modelMap.addAttribute(USER_LOGIN.getValue(), user);
                modelAndView.setViewName(REGISTRATION_PAGE.getPath());
                modelAndView.addAllObjects(modelMap);
            } else {
                create(user);
                modelAndView.addObject(CHECK_NEW_USER.getValue(), true);
                modelAndView.setViewName(SIGN_IN_PAGE.getPath());
            }
        } else {
            modelAndView.addObject(CHECK_NEW_USER.getValue(), true);
            modelAndView.setViewName(REGISTRATION_PAGE.getPath());
        }
        return modelAndView;
    }

    @Override
    public ModelAndView showProfile() {
        User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        ModelMap modelMap = new ModelMap();
        List<Order> orders = orderRepository.getOrdersByUserId(user.getId());
        List<Image> images = imageRepository.getImagesByPrimaryFlagAndUserId(user.getId());
        modelMap.addAttribute(ORDER_PRODUCTS_IMAGES.getValue(), images);
        modelMap.addAttribute(ORDERS.getValue(), orders);
        modelMap.addAttribute(USER.getValue(), user);
        modelMap.addAttribute(ACTIVE_BUTTON_NAV_MENU.getValue(), true);
        return new ModelAndView(PROFILE_PAGE.getPath(), modelMap);
    }

    @Override
    public void writeProfileToCsv(Writer writer) {
        try {
            User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            User userFromDB = userRepository.getUserById(user.getId());
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(writer)
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(userFromDB);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void writeOrderToCsv(int orderId, Writer writer) {
        try {
            Order order = orderRepository.getOrderById(orderId);
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(writer)
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(order);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public User getAuthorizationUserOrNull() {
        Authentication authentication=SecurityContextHolder.getContext().getAuthentication();
        boolean auth=authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ANONYMOUS"));
        if (!auth) {
            return (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        } else {
            log.info("An unauthorized user was received");
           return null;
        }
    }

    private boolean checkExistUserInDB(User user) {
        User userFromBase = userRepository.getUserByLogin(user.getLogin());
        return Optional.ofNullable(userFromBase).isPresent();
    }
}

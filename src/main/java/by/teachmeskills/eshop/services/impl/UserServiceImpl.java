package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.entities.BaseEntity;
import by.teachmeskills.eshop.entities.Order;
import by.teachmeskills.eshop.entities.Role;
import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.exceptions.UserException;
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

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Writer;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static by.teachmeskills.eshop.utils.EshopConstants.ALL_ROLES;
import static by.teachmeskills.eshop.utils.EshopConstants.ANONYMOUS_USER_LOGIN;
import static by.teachmeskills.eshop.utils.EshopConstants.CHECK_NEW_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.ID_ROLE_ADMIN;
import static by.teachmeskills.eshop.utils.EshopConstants.ID_ROLE_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.REDIRECT_TO_USERS_PAGE;
import static by.teachmeskills.eshop.utils.EshopConstants.ROLE_ADMIN;
import static by.teachmeskills.eshop.utils.EshopConstants.ROLE_ANONYMOUS;
import static by.teachmeskills.eshop.utils.EshopConstants.ROLE_USER;
import static by.teachmeskills.eshop.utils.EshopConstants.USER;
import static by.teachmeskills.eshop.utils.EshopConstants.USERS_FROM_DB;
import static by.teachmeskills.eshop.utils.EshopConstants.USER_LOGIN;
import static by.teachmeskills.eshop.utils.PagesPathEnum.PROFILE_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.REGISTRATION_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.SIGN_IN_PAGE;
import static by.teachmeskills.eshop.utils.PagesPathEnum.USERS_PAGE;

@Service
@Log4j
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;

    public UserServiceImpl(UserRepository userRepository, OrderRepository orderRepository, PasswordEncoder passwordEncoder, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.orderRepository = orderRepository;
        this.passwordEncoder = passwordEncoder;
        this.roleRepository = roleRepository;
    }

    @Override
    public User create(User entity) {
        entity.setPassword(passwordEncoder.encode(entity.getPassword()));
        return userRepository.saveAndFlush(entity);
    }

    @Override
    public List<User> read() {
        return userRepository.findAll();
    }

    @Override
    public User update(User entity) {
        Optional<User> user = userRepository.findById(entity.getId());
        if (user.isPresent()) {
            entity.setOrders(user.get().getOrders());
            return userRepository.saveAndFlush(entity);
        } else {
            log.error("User with id " + entity.getId() + " doesn't exists in DB");
            return null;
        }
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
            user.setBalance(BigDecimal.ZERO);
            if (checkExistUserInDB(user)) {
                ModelMap modelMap = new ModelMap();
                modelMap.addAttribute(CHECK_NEW_USER, false);
                modelMap.addAttribute(USER_LOGIN, user);
                modelAndView.setViewName(REGISTRATION_PAGE.getPath());
                modelAndView.addAllObjects(modelMap);
            } else {
                Optional<Role> role = roleRepository.findById(ID_ROLE_USER);
                if (role.isPresent()) {
                    Set<Role> roles = new HashSet<>();
                    roles.add(role.get());
                    user.setRoles(roles);
                } else {
                    log.warn("ROLE with ID " + ID_ROLE_USER + " doesn't exist");
                }
                create(user);
                modelAndView.addObject(CHECK_NEW_USER, true);
                modelAndView.setViewName(SIGN_IN_PAGE.getPath());
            }
        } else {
            modelAndView.addObject(CHECK_NEW_USER, true);
            modelAndView.setViewName(REGISTRATION_PAGE.getPath());
        }
        return modelAndView;
    }

    @Override
    public ModelAndView showProfile() {
        User userFromContext = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        ModelMap modelMap = new ModelMap();
        Optional<User> user = userRepository.findById(userFromContext.getId());
        if (user.isPresent()) {
            modelMap.addAttribute(USER, user.get());
        } else {
            log.error("User wasn't found");
        }
        return new ModelAndView(PROFILE_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView addUserOnUsersPage(User user, String role) throws UserException {
        ModelAndView modelAndView = new ModelAndView();
        if (Optional.ofNullable(user).isPresent()
                && Optional.ofNullable(user.getLogin()).isPresent()
                && Optional.ofNullable(user.getName()).isPresent()
                && Optional.ofNullable(user.getSurname()).isPresent()
                && Optional.ofNullable(user.getEmail()).isPresent()
                && Optional.ofNullable(user.getBirthDate()).isPresent()
                && Optional.ofNullable(user.getPassword()).isPresent()) {
            if (!checkExistUserInDB(user)) {
                setRolesForUserOnUsersPage(user, role);
                create(user);
                modelAndView.setViewName(REDIRECT_TO_USERS_PAGE);
                return modelAndView;
            } else {
                throw new UserException("User with the same login exists in DB");
            }
        } else {
            throw new UserException("All fields for the user are not filled in");
        }
    }

    @Override
    public ModelAndView getUsersDataForUsersPage() {
        ModelMap modelMap = new ModelMap();
        List<User> users = read();
        modelMap.addAttribute(USERS_FROM_DB, users);
        return new ModelAndView(USERS_PAGE.getPath(), modelMap);
    }

    @Override
    public ModelAndView updateUserOnUsersPage(User user, String role) throws UserException {
        if (!(user.getLogin().isBlank() || user.getPassword().isBlank())) {
            if (!user.getPassword().equals(userRepository.findById(user.getId()).get().getPassword())) {
                user.setPassword(passwordEncoder.encode(user.getPassword()));
            }
            setRolesForUserOnUsersPage(user, role);
            update(user);
            return new ModelAndView(REDIRECT_TO_USERS_PAGE);
        } else {
            throw new UserException("Login or Password mustn't be empty");
        }
    }

    @Override
    public ModelAndView deleteUserFromUsersPage(int id) {
        delete(id);
        return new ModelAndView(REDIRECT_TO_USERS_PAGE);
    }

    @Override
    public void writeProfileToCsv(HttpServletResponse response) {
        try {
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF8");
            response.addHeader("Content-Disposition", "attachment; filename=profile.csv");
            User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            User userFromDB = userRepository.findById(user.getId()).get();
            writeBeanToCsv(response.getWriter(), userFromDB);
        } catch (IOException e) {
            log.error(e.getMessage());
        }
    }

    private <T extends BaseEntity> void writeBeanToCsv(Writer writer, T entity) {
        try {
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(writer)
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(entity);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void writeOrderToCsv(int orderId, HttpServletResponse response) {
        try {
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF8");
            response.addHeader("Content-Disposition", "attachment; filename=order" + orderId + ".csv");
            Optional<Order> order = orderRepository.findById(orderId);
            writeBeanToCsv(response.getWriter(), order.get());
        } catch (IOException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public String getAuthorizationUserLoginOrDefault() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        boolean auth = authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals(ROLE_ANONYMOUS));
        if (!auth) {
            User user = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            return user.getLogin();
        } else {
            return ANONYMOUS_USER_LOGIN;
        }
    }

    private boolean checkExistUserInDB(User user) {
        Optional<User> userFromBase = userRepository.findUserByLogin(user.getLogin());
        return userFromBase.isPresent();
    }

    private void setRolesForUserOnUsersPage(User user, String role) {
        Set<Role> roles = new HashSet<>();
        switch (role) {
            case ROLE_ADMIN:
                Optional<Role> adminRole = roleRepository.findById(ID_ROLE_ADMIN);
                if (adminRole.isPresent()) {
                    roles.add(adminRole.get());
                    user.setRoles(roles);
                    break;
                } else {
                    log.error("ROLE_ADMIN wasn't found");
                }
            case ROLE_USER:
                Optional<Role> userRole = roleRepository.findById(ID_ROLE_USER);
                if (userRole.isPresent()) {
                    roles.add(userRole.get());
                    user.setRoles(roles);
                    break;
                } else {
                    log.error("ROLE_USER wasn't found");
                }
            case ALL_ROLES:
                roles = new HashSet<>(roleRepository.findAll());
                user.setRoles(roles);
                break;
        }
    }
}
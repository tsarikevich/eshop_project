package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.entities.Category;
import by.teachmeskills.eshop.entities.Image;
import by.teachmeskills.eshop.entities.User;
import by.teachmeskills.eshop.repositories.CategoryRepository;
import by.teachmeskills.eshop.repositories.ImageRepository;
import by.teachmeskills.eshop.services.CategoryService;
import by.teachmeskills.eshop.services.UserService;
import com.opencsv.CSVWriter;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Writer;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static by.teachmeskills.eshop.utils.PagesPathEnum.HOME_PAGE;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.ACTIVE_BUTTON_NAV_MENU;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CATEGORIES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.CATEGORIES_IMAGES;
import static by.teachmeskills.eshop.utils.RequestParamsEnum.USER;

@Service
@Log4j
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository categoryRepository;
    private final ImageRepository imageRepository;
    private final UserService userService;

    public CategoryServiceImpl(CategoryRepository categoryRepository, ImageRepository imageRepository, UserService userService) {
        this.categoryRepository = categoryRepository;
        this.imageRepository = imageRepository;
        this.userService = userService;
    }

    @Override
    public Category create(Category entity) {
        return categoryRepository.save(entity);
    }

    @Override
    public List<Category> read() {
        return categoryRepository.findAll();
    }

    @Override
    public Category update(Category entity) {
        Category category = categoryRepository.findCategoryById(entity.getId());
        return categoryRepository.save(category);
    }

    @Override
    public void delete(int id) {
        categoryRepository.deleteById(id);
    }

    @Override
    public ModelAndView getAllCategories() {
        ModelMap modelMap = new ModelMap();
        List<Category> categories = read();
        List<Image> categoriesImages = imageRepository.getImagesByProductExists();
        modelMap.addAttribute(USER.getValue(), userService.getAuthorizationUserOrNull());
        modelMap.addAttribute(CATEGORIES.getValue(), categories);
        modelMap.addAttribute(ACTIVE_BUTTON_NAV_MENU.getValue(), true);
        modelMap.addAttribute(CATEGORIES_IMAGES.getValue(), categoriesImages);
        return new ModelAndView(HOME_PAGE.getPath(), modelMap);
    }

    @Override
    public void writeCategoriesToCsv(Writer writer) {
        try {
            List<Category> categories = read();
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(writer)
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(categories);
        } catch (CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void saveCategoriesFromCsv(MultipartFile file) {
        List<Category> csvCategories = parseCsv(file);
        if (Optional.ofNullable(csvCategories).isPresent() && csvCategories.size() > 0) {
            categoryRepository.saveAll(csvCategories);
        }
    }

    private List<Category> parseCsv(MultipartFile file) {
        if (Optional.ofNullable(file).isPresent()) {
            try (Reader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
                CsvToBean<Category> csvToBean = new CsvToBeanBuilder(reader)
                        .withType(Category.class)
                        .withIgnoreLeadingWhiteSpace(true)
                        .withSeparator(',')
                        .build();
                return csvToBean.parse();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            log.error("Empty CSV file is uploaded.");
        }
        return Collections.emptyList();
    }
}


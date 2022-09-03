package by.teachmeskills.eshop.services.impl;

import by.teachmeskills.eshop.entities.Category;
import by.teachmeskills.eshop.repositories.CategoryRepository;
import by.teachmeskills.eshop.services.CategoryService;
import com.opencsv.CSVWriter;
import com.opencsv.bean.CsvToBean;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import lombok.extern.log4j.Log4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static by.teachmeskills.eshop.utils.EshopConstants.CATEGORIES;
import static by.teachmeskills.eshop.utils.PagesPathEnum.HOME_PAGE;

@Service
@Log4j
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository categoryRepository;
    private final ProductServiceImpl productService;

    public CategoryServiceImpl(CategoryRepository categoryRepository, ProductServiceImpl productService) {
        this.categoryRepository = categoryRepository;
        this.productService = productService;
    }

    @Override
    public Category create(Category entity) {
        return categoryRepository.saveAndFlush(entity);
    }

    @Override
    public List<Category> read() {
        return categoryRepository.findAll();
    }

    @Override
    public Category update(Category entity) {
        Optional<Category> category = categoryRepository.findById(entity.getId());
        if (category.isPresent()) {
            return categoryRepository.saveAndFlush(entity);
        }
        log.error("Category doesn't exist");
        return null;
    }

    @Override
    public void delete(int id) {
        categoryRepository.deleteById(id);
    }

    @Override
    public ModelAndView getAllCategories(int pageNumber, int pageSize) {
        ModelMap modelMap = new ModelMap();
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("id"));
        Page<Category> page = categoryRepository.findAll(paging);
        modelMap.addAttribute(CATEGORIES, page.getContent());
        productService.addAttributeToModelMap(page, pageNumber, pageSize, modelMap);
        return new ModelAndView(HOME_PAGE.getPath(), modelMap);
    }

    @Override
    public void writeCategoriesToCsv(HttpServletResponse response) {
        try {
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF8");
            response.addHeader("Content-Disposition", "attachment; filename=categories.csv");
            List<Category> categories = read();
            StatefulBeanToCsv beanToCsv = new StatefulBeanToCsvBuilder(response.getWriter())
                    .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER)
                    .build();
            beanToCsv.write(categories);
        } catch (IOException | CsvDataTypeMismatchException | CsvRequiredFieldEmptyException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public void saveCategoriesFromCsv(MultipartFile file) {
        try {
            List<Category> csvCategories = parseCsv(file);
            if (Optional.ofNullable(csvCategories).isPresent() && csvCategories.size() > 0) {
                categoryRepository.saveAll(csvCategories);
            } else {
                throw new FileNotFoundException("A file wasn't found for upload new categories");
            }
        } catch (Exception e) {
            log.error(e.getMessage());
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
                log.error(e.getMessage());
            }
        } else {
            log.error("Empty CSV file is uploaded.");
        }
        return Collections.emptyList();
    }
}


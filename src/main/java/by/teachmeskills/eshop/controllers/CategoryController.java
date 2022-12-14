package by.teachmeskills.eshop.controllers;

import by.teachmeskills.eshop.services.ProductService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletResponse;
import static by.teachmeskills.eshop.utils.EshopConstants.CATEGORY_ID;
import static by.teachmeskills.eshop.utils.EshopConstants.CATEGORY_NAME;
import static by.teachmeskills.eshop.utils.EshopConstants.FILE;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_NUMBER;
import static by.teachmeskills.eshop.utils.EshopConstants.PAGE_SIZE;

@RestController
@RequestMapping("/category")
public class CategoryController {
    private final ProductService productService;

    public CategoryController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("{categoryName}/{categoryId}")
    public ModelAndView openCategoryProductPage(@PathVariable String categoryName,
                                                @PathVariable int categoryId,
                                                @RequestParam(value = PAGE_NUMBER, defaultValue = "0") int pageNumber,
                                                @RequestParam(value = PAGE_SIZE, defaultValue = "5") int pageSize) {
        return productService.getCategoryProductsData(categoryId, categoryName, pageNumber, pageSize);
    }

    @GetMapping("/download")
    public void downloadCsvFile(HttpServletResponse response, @RequestParam(CATEGORY_ID) int id){
        productService.writeProductsCategoryToCsv(id, response);
    }

    @PostMapping("/upload")
    public ModelAndView uploadCategoriesFromFile(@RequestParam(FILE) MultipartFile file,
                                                 @RequestParam(CATEGORY_ID) int id,
                                                 @RequestParam(PAGE_SIZE) int pageSize,
                                                 @RequestParam(value = PAGE_NUMBER, defaultValue = "0") int pageNumber,
                                                 @RequestParam(CATEGORY_NAME) String nameCategory) {
        productService.saveProductsCategoryFromCsv(id, file);
        return productService.getCategoryProductsData(id, nameCategory, pageNumber, pageSize);
    }
}

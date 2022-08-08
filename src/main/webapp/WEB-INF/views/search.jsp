<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Search Page</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        document.getElementById('categoryName').value = "<?php echo $_GET['name'];?>";
    </script>
</head>
<body>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<ul class="TopNavMenu">
    <li><a href='/home'><i class="fa fa-fw fa-home"></i> Главная</a></li>
    <li style="float:right"><a href='/cart'><i class="fa fa-fw fa-shopping-cart"></i>
        Корзина</a></li>
    <li style="float:right"><a href='/profile'><i class="fa fa-fw fa-user"></i>
        Пользователь</a></li>
    <c:choose>
        <c:when test="${activeButtonNavMenu}">
            <li class="active" style="float:right"><a href='/search'><i class="fa fa-fw fa-search"></i>
                Поиск</a></li>
        </c:when>
        <c:otherwise>
            <li style="float:right"><a href='/search'><i class="fa fa-fw fa-shopping-cart"></i>
                Поиск</a></li>
        </c:otherwise>
    </c:choose>
</ul>
<div class="container-fluid">
    <form method="post" action="${contextPath}/search">
        <input id="inpSearchLbl" type="search" placeholder="Поиск по названию или описанию товара..."
               name="searchKey" value="${searchParams.getSearchKey()}">
        <div class="row">
            <div class="col-sm-4" style="background-color:lavender;">
                <select name="categoryName">
                    <c:if test="${empty searchParams.getCategoryName()}">
                        <option selected value="">Не выбрано</option>
                    </c:if>
                    <c:if test="${not empty searchParams.getCategoryName()}">
                        <option selected
                                value="${searchParams.getCategoryName()}">${searchParams.getCategoryName()}</option>
                    </c:if>
                    <option value="Mobile phones">Mobile phones</option>
                    <option value="Laptops">Laptops</option>
                    <option value="GPS Navigators">GPS Navigators</option>
                    <option value="Fridges">Fridges</option>
                    <option value="Cars">Cars</option>
                    <option value="Cameras">Cameras</option>
                    <option value="">Не выбрано</option>
                </select>
                <br>
                <input id="minPrice" type="number" min="0" placeholder="цена от" name="minPrice"
                       value="${searchParams.getMinPrice()}">
                <input id="maxPrice" type="number" min="0" placeholder="цена до" name="maxPrice"
                       value="${searchParams.getMaxPrice()}">
                <a href="${contextPath}/search?pageNumber=${pageNumber+1}&pageSize=${pageSize}&searchKey=${searchParams.getSearchKey()}&categoryName=${searchParams.getCategoryName()}&minPrice=${searchParams.getMinPrice()}&maxPrice=${searchParams.getMaxPrice()}">
                    <button id="searchBtn" type="submit">Применить</button>
                </a>
    </form>
</div>
<div class="col-sm-8" style="background-color:lavenderblush;">
    <c:if test="${not empty foundProducts}">
    <h3><p class="text-center">Найденные продукты по вашему запросу:</p></h3>
    <c:forEach items="${foundProducts}" var="product">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-1" style="background-color:white;">
                    <c:forEach items="${foundImages}" var="image">
                        <c:if test="${product.getId()==image.product.getId()}">
                            <a href="${contextPath}/product/${product.getId()}">
                                <img src="${contextPath}/images/${image.getImagePath()}"
                                     alt="${image.getImagePath()}" class="responsive"></a>
                        </c:if>
                    </c:forEach>
                </div>
                <div class="col" style="background-color:white;">
                    <p><b class="font-italic">Модель:</b> ${product.getName()}</p>
                    <p><b class="font-italic">Описание:</b> ${product.getDescription()}</p>
                    <p><b class="font-italic">Цена:</b> ${product.getPrice()} руб.</p>
                </div>
            </div>
        </div>
        <br>
    </c:forEach>
    <div>
        <nav aria-label>
            <ul class="pagination justify-content-center">
                <c:choose>
                    <c:when test="${not isFirstPage}">
                        <li class="page-item">
                            <form method="post"
                                  action="${contextPath}/search?pageNumber=${pageNumber-1}&pageSize=${pageSize}&searchKey=${searchParams.getSearchKey()}&categoryName=${searchParams.getCategoryName()}&minPrice=${searchParams.getMinPrice()}&maxPrice=${searchParams.getMaxPrice()}">
                                <button type="submit" class="page-link">Предыдущая</button>
                            </form>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link">Предыдущая</a>
                        </li>
                    </c:otherwise>
                </c:choose>
                <c:forEach begin="0" end="${totalPages-1}" var="i">
                    <c:choose>
                        <c:when test="${pageNumber eq i}">
                            <li class="page-item">
                                <a class="page-link active">${i+1}</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item">
                                <form method="post"
                                      action="${contextPath}/search?pageNumber=${i}&pageSize=${pageSize}&searchKey=${searchParams.getSearchKey()}&categoryName=${searchParams.getCategoryName()}&minPrice=${searchParams.getMinPrice()}&maxPrice=${searchParams.getMaxPrice()}">
                                    <button type="submit" class="page-link">${i+1}</button>
                                </form>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${not isLastPage}">
                        <li class="page-item">
                            <form method="post"
                                  action="${contextPath}/search?pageNumber=${pageNumber+1}&pageSize=${pageSize}&searchKey=${searchParams.getSearchKey()}&categoryName=${searchParams.getCategoryName()}&minPrice=${searchParams.getMinPrice()}&maxPrice=${searchParams.getMaxPrice()}">
                                <button type="submit" class="page-link">Следующая</button>
                            </form>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link">Следующая</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</div>
</div>
</div>
</c:if>
<c:if test="${empty foundProducts}">
    <h3><p class="text-center">Введите новый запрос</p></h3>
</c:if>
</body>
</html>



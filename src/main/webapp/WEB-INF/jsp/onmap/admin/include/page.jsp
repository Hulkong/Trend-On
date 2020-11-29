<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
		<script type="text/javascript">
		$(document).ready(function() {
			var page = $("#page").val();

			$(".nextPage").click(function() {
				$("#searchFrom #page").val($(this).text());
				$("#searchFrom").submit();
			});

			$(".prev").click(function() {
				$("#searchFrom #page").val(Number(page)-1);
				$("#searchFrom").submit();
			});

			$(".next").click(function() {
				$("#searchFrom #page").val(Number(page)+1);
				$("#searchFrom").submit();
			});

			$(".firs").click(function() {
				$("#searchFrom #page").val(1);
				$("#searchFrom").submit();
			});

			$(".endPage").click(function() {
				$("#searchFrom #page").val($("#endPage").val());
				$("#searchFrom").submit();
			});
		});
		</script>

							<div class="paginate">
<c:if test="${pageInfo.startPage > 1 }">
								<a href="#" class="firs"></a>
</c:if>
<c:if test="${pageInfo.page > 1 }">
								<a href="#" class="prev"></a>
</c:if>
								<span class="pg_lst">

<c:forEach var="page" begin="${pageInfo.startPage}" end="${pageInfo.endPage}" step="1" varStatus="status" >
	<c:if test="${pageInfo.page == page}">
									<strong title="현재 페이지">${page}</strong>
	</c:if>
	<c:if test="${pageInfo.page != page}">
									<a href="#" class="nextPage">${page}</a>
	</c:if>
</c:forEach>
								</span>
<c:if test="${pageInfo.totalPage > pageInfo.page }">
								<a href="#" class="next"></a>
</c:if>
<c:if test="${pageInfo.totalPage > pageInfo.endPage }">
								<a href="#" class="last"></a>
</c:if>
							</div>
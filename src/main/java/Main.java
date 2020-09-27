import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.ParseTree;

import com.google.common.base.Objects;

public class Main {

    public static class Sort {
        public final String column;
        public final boolean desc;

        public Sort(String column, String order) {
            this.column = column;
            this.desc = order.toUpperCase().equals("DESC");
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Sort)) return false;
            Sort sort = (Sort) o;
            return desc == sort.desc &&
                    Objects.equal(column, sort.column);
        }

        @Override
        public int hashCode() {
            return Objects.hashCode(column, desc);
        }

        @Override
        public String toString() {
            return "Sort{" +
                    "column='" + column + '\'' +
                    ", desc=" + desc +
                    '}';
        }
    }

    public static class Query {
        public final List<String> columns;
        public final List<String> fromSources;
        public final List<String> joins;
        public final String whereClause;
        public final List<String> groupByColumns;
        public final List<Sort> sortColumns;
        public final Integer limit;
        public final Integer offset;

        public Query(
                List<String> columns, List<String> fromSources, List<String> joins, String whereClause,
                List<String> groupByColumns, List<Sort> sortColumns, Integer limit, Integer offset
        ) {
            this.columns = columns;
            this.fromSources = fromSources;
            this.joins = joins;
            this.whereClause = whereClause;
            this.groupByColumns = groupByColumns;
            this.sortColumns = sortColumns;
            this.limit = limit;
            this.offset = offset;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof Query)) return false;
            Query query = (Query) o;
            return Objects.equal(columns, query.columns) &&
                    Objects.equal(fromSources, query.fromSources) &&
                    Objects.equal(joins, query.joins) &&
                    Objects.equal(whereClause, query.whereClause) &&
                    Objects.equal(groupByColumns, query.groupByColumns) &&
                    Objects.equal(sortColumns, query.sortColumns) &&
                    Objects.equal(limit, query.limit) &&
                    Objects.equal(offset, query.offset);
        }

        @Override
        public int hashCode() {
            return Objects.hashCode(columns, fromSources, joins, whereClause, groupByColumns, sortColumns, limit, offset);
        }

        @Override
        public String toString() {
            return "Query{" +
                    "columns=" + columns +
                    ", fromSources=" + fromSources +
                    ", joins=" + joins +
                    ", whereClauses=" + whereClause +
                    ", groupByColumns=" + groupByColumns +
                    ", sortColumns=" + sortColumns +
                    ", limit=" + limit +
                    ", offset=" + offset +
                    '}';
        }
    }

    public static Query parse(String query) {
        SqlLexer lexer = new SqlLexer(CharStreams.fromString(query.toUpperCase()));
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        SqlParser parser = new SqlParser(tokenStream);
        SqlParser.QuerySpecificationContext querySpecificationContext = parser.querySpecification();
        return new Query(
                querySpecificationContext.selectElements().selectElement().stream().map(RuleContext::getText).collect(Collectors.toList()),
                querySpecificationContext.fromClause().tableSources().getRuleContexts(SqlParser.TableSourceContext.class)
                        .stream()
                        .flatMap((var c) -> c.getRuleContexts(SqlParser.TableSourceItemContext.class).stream())
                        .map(ParseTree::getText)
                        .collect(Collectors.toList()),
                querySpecificationContext.fromClause().tableSources()
                        .getRuleContexts(SqlParser.TableSourceContext.class).stream()
                        .flatMap((var c) -> c.getRuleContexts(SqlParser.JoinPartContext.class).stream())
                        .flatMap((var ctx) -> ctx.getRuleContexts(SqlParser.TableSourceItemContext.class).stream())
                        .map(ParserRuleContext::getText)
                        .collect(Collectors.toList()),
                querySpecificationContext.fromClause().whereExpr == null ? null
                        : querySpecificationContext.fromClause().whereExpr.getText(),
                querySpecificationContext.fromClause().groupByItem().stream().map(RuleContext::getText).collect(Collectors.toList()),
                Optional.ofNullable(querySpecificationContext.orderByClause())
                        .map(SqlParser.OrderByClauseContext::orderByExpression).stream().flatMap(Collection::stream)
                        .map(c -> new Sort(c.expression().getText(), Optional.ofNullable(c.order).map(Token::getText).orElse("")))
                        .collect(Collectors.toList()),
                Optional.ofNullable(querySpecificationContext.limitClause())
                        .map(l -> l.limit)
                        .map(RuleContext::getText)
                        .map(Integer::parseInt)
                        .orElse(null),
                Optional.ofNullable(querySpecificationContext.limitClause())
                        .map(l -> l.offset)
                        .map(RuleContext::getText)
                        .map(Integer::parseInt)
                        .orElse(null)
        );
    }

    public static void main(String[] args) {
        System.out.println(parse("SELECT author.name, COUNT(book.id), SUM(book.cost) \n" +
                "FROM auth, (SELECT id, name FROM au) author\n" +
                "LEFT JOIN book ON (author.id = book.author_id) \n" +
                "WHERE (a.name != 'a' OR a.name is not true) AND b.id = 5\n" +
                "GROUP BY a.name, a.name \n" +
                "HAVING COUNT(*) > 1 AND SUM(b.cost) > 500 \n" +
                "ORDER BY a.name \n" +
                "LIMIT 10;"));
        System.out.println(parse("SELECT author.name FROM author;"));
    }
}

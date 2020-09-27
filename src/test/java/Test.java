import org.junit.Assert;

import com.google.common.collect.ImmutableList;

public class Test {

    @org.junit.Test
    public void test() {
        Assert.assertEquals(
                new Main.Query(ImmutableList.of("AUTHOR.NAME", "COUNT(BOOK.ID)", "SUM(BOOK.COST)"),
                        ImmutableList.of("AUTH", "(SELECTID,NAMEFROMAU)AUTHOR"),
                        ImmutableList.of("BOOK"),
                        "(A.NAME!='A'ORA.NAMEISNOTTRUE)ANDB.ID=5",
                        ImmutableList.of("A.NAME", "A.NAME"),
                        ImmutableList.of(new Main.Sort("A.NAME", "ASC")),
                        10, null),
                Main.parse("SELECT author.name, COUNT(book.id), SUM(book.cost) \n" +
                        "FROM auth, (SELECT id, name FROM au) author\n" +
                        "LEFT JOIN book ON (author.id = book.author_id) \n" +
                        "WHERE (a.name != 'a' OR a.name is not true) AND b.id = 5\n" +
                        "GROUP BY a.name, a.name \n" +
                        "HAVING COUNT(*) > 1 AND SUM(b.cost) > 500 \n" +
                        "ORDER BY a.name \n" +
                        "LIMIT 10;"));
    }
}

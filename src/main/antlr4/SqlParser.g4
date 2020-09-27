parser grammar SqlParser;

options { tokenVocab=SqlLexer; }

selectStatement
    : querySpecification
    | queryExpression
    ;

orderByClause
    : ORDER BY orderByExpression (',' orderByExpression)*
    ;

orderByExpression
    : expression order=(ASC | DESC)?
    ;

tableSources
    : tableSource (',' tableSource)*
    ;

tableSource
    : tableSourceItem joinPart*
    | '(' tableSourceItem joinPart* ')'
    ;

tableSourceItem
    : tableName
    | (
      selectStatement
      | '(' parenthesisSubquery=selectStatement ')'
      )
      AS? alias=uid
    | '(' tableSources ')'
    ;

joinPart
    : (INNER | CROSS)? JOIN tableSourceItem
      (
        ON expression
        | USING '(' uidList ')'
      )?
    | (LEFT | RIGHT) OUTER? JOIN tableSourceItem
        (
          ON expression
          | USING '(' uidList ')'
        )
    | NATURAL ((LEFT | RIGHT) OUTER?)? JOIN tableSourceItem
    ;

queryExpression
    : '(' querySpecification ')'
    | '(' queryExpression ')'
    ;

querySpecification
    : SELECT selectSpec* selectElements
      fromClause? orderByClause? limitClause?
    ;

selectSpec
    : (ALL | DISTINCT | DISTINCTROW)
    ;

selectElements
    : (star='*' | selectElement ) (',' selectElement)*
    ;

selectElement
    : fullId '.' '*'
    | fullColumnName (AS? uid)?
    | functionCall (AS? uid)?
    ;

fromClause
    : FROM tableSources
      (WHERE whereExpr=expression)?
      (
        GROUP BY
        groupByItem (',' groupByItem)*
      )?
      (HAVING havingExpr=expression)?
    ;

groupByItem
    : expression order=(ASC | DESC)?
    ;

limitClause
    : LIMIT
    (
      (offset=limitClauseAtom ',')? limit=limitClauseAtom
      | limit=limitClauseAtom OFFSET offset=limitClauseAtom
    )
    ;

limitClauseAtom
	: decimalLiteral
	;

fullId
    : uid (DOT_ID | '.' uid)?
    ;

tableName
    : fullId
    ;

fullColumnName
    : uid (dottedId dottedId? )?
    ;

charsetName
    : BINARY
    | STRING_LITERAL
    | CHARSET_REVERSE_QOUTE_STRING
    ;

collationName
    : uid | STRING_LITERAL;

uid
    : simpleId
    | REVERSE_QUOTE_ID
    | CHARSET_REVERSE_QOUTE_STRING
    ;

simpleId
    : ID
    | intervalTypeBase
    | dataTypeBase
    | keywordsCanBeId
    | functionNameBase
    ;

dottedId
    : DOT_ID
    | '.' uid
    ;

decimalLiteral
    : DECIMAL_LITERAL | ZERO_DECIMAL | ONE_DECIMAL | TWO_DECIMAL
    ;

stringLiteral
    : (
        STRING_CHARSET_NAME? STRING_LITERAL
        | START_NATIONAL_STRING_LITERAL
      ) STRING_LITERAL+
    | (
        STRING_CHARSET_NAME? STRING_LITERAL
        | START_NATIONAL_STRING_LITERAL
      ) (COLLATE collationName)?
    ;

booleanLiteral
    : TRUE | FALSE;

hexadecimalLiteral
    : STRING_CHARSET_NAME? HEXADECIMAL_LITERAL;

nullNotnull
    : NOT? NULL_LITERAL
    ;

constant
    : stringLiteral | decimalLiteral
    | '-' decimalLiteral
    | hexadecimalLiteral | booleanLiteral
    | NOT? nullLiteral=NULL_LITERAL
    ;

convertedDataType
    : typeName=(BINARY| NCHAR) lengthOneDimension?
    | typeName=CHAR lengthOneDimension? ((CHARACTER SET | CHARSET) charsetName)?
    | typeName=(DATE | DATETIME | TIME | JSON)
    | typeName=DECIMAL lengthTwoDimension?
    | (SIGNED | UNSIGNED) INTEGER?
    ;

lengthOneDimension
    : '(' decimalLiteral ')'
    ;

lengthTwoDimension
    : '(' decimalLiteral ',' decimalLiteral ')'
    ;

uidList
    : uid (',' uid)*
    ;

expressions
    : expression (',' expression)*
    ;

functionCall
    : specificFunction
    | aggregateWindowedFunction
    | scalarFunctionName '(' functionArgs? ')'
    | fullId '(' functionArgs? ')'
    ;

specificFunction
    : (
      CURRENT_DATE | CURRENT_TIME | CURRENT_TIMESTAMP
      | CURRENT_USER | LOCALTIME
      )
    | CONVERT '(' expression separator=',' convertedDataType ')'
    | CONVERT '(' expression USING charsetName ')'
    | CAST '(' expression AS convertedDataType ')'
    | CHAR '(' functionArgs  (USING charsetName)? ')'
    | (SUBSTR | SUBSTRING)
      '('
        (
          sourceString=stringLiteral
          | sourceExpression=expression
        ) FROM
        (
          fromDecimal=decimalLiteral
          | fromExpression=expression
        )
        (
          FOR
          (
            forDecimal=decimalLiteral
            | forExpression=expression
          )
        )?
      ')'
    | TRIM
      '('
        positioinForm=(BOTH | LEADING | TRAILING)
        (
          sourceString=stringLiteral
          | sourceExpression=expression
        )?
        FROM
        (
          fromString=stringLiteral
          | fromExpression=expression
        )
      ')'
    | TRIM
      '('
        (
          sourceString=stringLiteral
          | sourceExpression=expression
        )
        FROM
        (
          fromString=stringLiteral
          | fromExpression=expression
        )
      ')'
    ;

aggregateWindowedFunction
    : (AVG | MAX | MIN | SUM)
      '(' aggregator=(ALL | DISTINCT)? functionArg ')'
    | COUNT '(' (starArg='*' | aggregator=ALL? functionArg) ')'
    | COUNT '(' aggregator=DISTINCT functionArgs ')'
    | (
        BIT_AND | BIT_OR | BIT_XOR | STD | STDDEV
      ) '(' aggregator=ALL? functionArg ')'
    ;

scalarFunctionName
    : functionNameBase
    | ASCII | CURDATE | CURRENT_DATE | CURRENT_TIME
    | CURRENT_TIMESTAMP | CURTIME | DATE_ADD | DATE_SUB
    | LOCALTIME | LOCALTIMESTAMP | MID | NOW
    | REPLACE | SUBSTR | SUBSTRING | SYSDATE | TRIM
    | UTC_DATE | UTC_TIME | UTC_TIMESTAMP
    ;

functionArgs
    : (constant | fullColumnName | functionCall | expression)
    (
      ','
      (constant | fullColumnName | functionCall | expression)
    )*
    ;

functionArg
    : constant | fullColumnName | functionCall | expression
    ;

expression
    : notOperator=(NOT | '!') expression
    | expression logicalOperator expression
    | predicate IS NOT? testValue=(TRUE | FALSE | UNKNOWN)
    | predicate
    ;

predicate
    : predicate NOT? IN '(' (selectStatement | expressions) ')'
    | predicate IS nullNotnull
    | left=predicate comparisonOperator right=predicate
    | predicate comparisonOperator
      quantifier=(ALL | ANY | SOME) '(' selectStatement ')'
    | predicate NOT? BETWEEN predicate AND predicate
    | predicate SOUNDS LIKE predicate
    | predicate NOT? LIKE predicate (ESCAPE STRING_LITERAL)?
    | predicate NOT? regex=(REGEXP | RLIKE) predicate
    | expressionAtom
    | predicate MEMBER OF '(' predicate ')'
    ;

expressionAtom
    : constant
    | fullColumnName
    | functionCall
    | expressionAtom COLLATE collationName
    | unaryOperator expressionAtom
    | BINARY expressionAtom
    | '(' expression (',' expression)* ')'
    | EXISTS '(' selectStatement ')'
    | '(' selectStatement ')'
    | left=expressionAtom bitOperator right=expressionAtom
    | left=expressionAtom mathOperator right=expressionAtom
    | left=expressionAtom jsonOperator right=expressionAtom
    ;

unaryOperator
    : '!' | '~' | '+' | '-' | NOT
    ;

comparisonOperator
    : '=' | '>' | '<' | '<' '=' | '>' '='
    | '<' '>' | '!' '=' | '<' '=' '>'
    ;

logicalOperator
    : AND | '&' '&' | XOR | OR | '|' '|'
    ;

bitOperator
    : '<' '<' | '>' '>' | '&' | '^' | '|'
    ;

mathOperator
    : '*' | '/' | '%' | DIV | MOD | '+' | '-' | '--'
    ;

jsonOperator
    : '-' '>' | '-' '>' '>'
    ;

intervalTypeBase
    : QUARTER | MONTH | DAY | HOUR
    | MINUTE | WEEK | SECOND | MICROSECOND
    ;

dataTypeBase
    : DATE | TIME | TIMESTAMP | DATETIME | YEAR | ENUM | TEXT
    ;

keywordsCanBeId
    : STRING
    ;

functionNameBase
      : ABS | UPPER | SIN | COS | SQRT //etc
    ;
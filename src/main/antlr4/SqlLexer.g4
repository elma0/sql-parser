lexer grammar SqlLexer;

channels { MYSQLCOMMENT, ERRORCHANNEL }

SPACE:                               [ \t\r\n]+    -> channel(HIDDEN);
COMMENT_INPUT:                       '/*' .*? '*/' -> channel(HIDDEN);
LINE_COMMENT:                        (
                                       ('-- ' | '#') ~[\r\n]* ('\r'? '\n' | EOF)
                                       | '--' ('\r'? '\n' | EOF)
                                     ) -> channel(HIDDEN);

ALL:                                 'ALL';
ASCII:                               'ASCII';
AND:                                 'AND';
BETWEEN:                             'BETWEEN';
CURRENT_USER:                        'CURRENT_USER';
CAST:                                'CAST';
UTF8:                                'UTF8';
DATE_FORMAT:                         'DATE_FORMAT';
DAYNAME:                             'DAYNAME';
DAYOFMONTH:                          'DAYOFMONTH';
DAYOFWEEK:                           'DAYOFWEEK';
DAYOFYEAR:                           'DAYOFYEAR';
EXISTS:                              'EXISTS';
DISTINCT:                            'DISTINCT';
DISTINCTROW:                         'DISTINCTROW';
JOIN:                                'JOIN';
KEY:                                 'KEY';
CONVERT:                             'CONVERT';
GROUP:                               'GROUP';
HAVING:                              'HAVING';
CROSS:                               'CROSS';
LEFT:                                'LEFT';
RIGHT:                               'RIGHT';
OUTER:                               'OUTER';
COLLATE:                             'COLLATE';
ON:                                  'ON';
SELECT:                              'SELECT';
FROM:                                'FROM';
WHERE:                               'WHERE';
USING:                               'USING';
IS:                                  'IS';
IN:                                  'IN';
ANY:                                 'ANY';
SOME:                                'SOME';
UNKNOWN:                             'UNKNOWN';
LIMIT:                               'LIMIT';
LIKE:                                'LIKE';
OFFSET:                              'OFFSET';
BINARY:                              'BINARY';
TRUE:                                'TRUE';
FALSE:                               'FALSE';
NOT:                                 'NOT';
NATURAL:                             'NATURAL';
NULL_LITERAL:                        'NULL';
NCHAR:                               'NCHAR';
CHARACTER:                           'CHARACTER';
INNER:                               'INNER';
SET:                                 'SET';
CHARSET:                             'CHARSET';
JSON:                                'JSON';
REPLACE:                             'REPLACE';
DECIMAL:                             'DECIMAL';
RLIKE:                               'RLIKE';
REGEXP:                              'REGEXP';
DATE:                                'DATE';
TIME:                                'TIME';
TIMESTAMP:                           'TIMESTAMP';
DATETIME:                            'DATETIME';
YEAR:                                'YEAR';
CHAR:                                'CHAR';
SIGNED:                              'SIGNED';
UNSIGNED:                            'UNSIGNED';
INTEGER:                             'INTEGER';
YEAR_MONTH:                          'YEAR_MONTH';
DAY_HOUR:                            'DAY_HOUR';
DAY_MINUTE:                          'DAY_MINUTE';
DAY_SECOND:                          'DAY_SECOND';
HOUR_MINUTE:                         'HOUR_MINUTE';
HOUR_SECOND:                         'HOUR_SECOND';
MINUTE_SECOND:                       'MINUTE_SECOND';
SECOND_MICROSECOND:                  'SECOND_MICROSECOND';
MINUTE_MICROSECOND:                  'MINUTE_MICROSECOND';
HOUR_MICROSECOND:                    'HOUR_MICROSECOND';
DAY_MICROSECOND:                     'DAY_MICROSECOND';
ORDER:                               'ORDER';
ABS:                                  'ABS';
BY:                                  'BY';
ASC:                                 'ASC';
DESC:                                'DESC';
PARTITION:                           'PARTITION';
AS:                                  'AS';
USE:                                 'USE';
IGNORE:                              'IGNORE';
FOR:                                 'FOR';
CURRENT_DATE:                        'CURRENT_DATE';
CURRENT_TIME:                        'CURRENT_TIME';
CURRENT_TIMESTAMP:                   'CURRENT_TIMESTAMP';
UTC_DATE:                            'UTC_DATE';
UTC_TIME:                            'UTC_TIME';
UTC_TIMESTAMP:                       'UTC_TIMESTAMP';
LOCALTIME:                           'LOCALTIME';
CURDATE:                             'CURDATE';
CURTIME:                             'CURTIME';
DATE_ADD:                            'DATE_ADD';
DATE_SUB:                            'DATE_SUB';
EXTRACT:                             'EXTRACT';
LOCALTIMESTAMP:                      'LOCALTIMESTAMP';
NOW:                                 'NOW';
SUBSTR:                              'SUBSTR';
SUBSTRING:                           'SUBSTRING';
TRIM:                                'TRIM';
SYSDATE:                             'SYSDATE';
BOTH:                                'BOTH';
LEADING:                             'LEADING';
TRAILING:                            'TRAILING';
AVG:                                 'AVG';
MAX:                                 'MAX';
MIN:                                 'MIN';
STD:                                 'STD';
STDDEV:                              'STDDEV';
SUM:                                 'SUM';
COUNT:                               'COUNT';
BIT_AND:                             'BIT_AND';
BIT_OR:                              'BIT_OR';
BIT_XOR:                             'BIT_XOR';
XOR:                                 'XOR';
OR:                                  'OR';
ENUM:                                'ENUM';
TEXT:                                'TEXT';
STRING:                              'STRING';
SOUNDS:                              'SOUNDS';
MID:                                 'MID';
ESCAPE:                              'ESCAPE';
MEMBER:                              'MEMBER';
OF:                                  'OF';

UPPER:                               'UPPER';
SIN:                                 'SIN';
COS:                                 'COS';
SQRT:                                'SQRT';

QUARTER:                             'QUARTER';
MONTH:                               'MONTH';
DAY:                                 'DAY';
HOUR:                                'HOUR';
MINUTE:                              'MINUTE';
WEEK:                                'WEEK';
SECOND:                              'SECOND';
MICROSECOND:                         'MICROSECOND';

STAR:                                '*';
DIVIDE:                              '/';
MODULE:                              '%';
PLUS:                                '+';
MINUSMINUS:                          '--';
MINUS:                               '-';
DIV:                                 'DIV';
MOD:                                 'MOD';


EQUAL_SYMBOL:                        '=';
GREATER_SYMBOL:                      '>';
LESS_SYMBOL:                         '<';
EXCLAMATION_SYMBOL:                  '!';


BIT_NOT_OP:                          '~';
BIT_OR_OP:                           '|';
BIT_AND_OP:                          '&';
BIT_XOR_OP:                          '^';


DOT:                                 '.';
LR_BRACKET:                          '(';
RR_BRACKET:                          ')';
COMMA:                               ',';
SEMI:                                ';';
AT_SIGN:                             '@';
ZERO_DECIMAL:                        '0';
ONE_DECIMAL:                         '1';
TWO_DECIMAL:                         '2';
SINGLE_QUOTE_SYMB:                   '\'';
DOUBLE_QUOTE_SYMB:                   '"';
REVERSE_QUOTE_SYMB:                  '`';
COLON_SYMB:                          ':';

fragment QUOTE_SYMB
    : SINGLE_QUOTE_SYMB | DOUBLE_QUOTE_SYMB | REVERSE_QUOTE_SYMB
    ;

CHARSET_REVERSE_QOUTE_STRING:        '`' CHARSET_NAME '`';


FILESIZE_LITERAL:                    DEC_DIGIT+ ('K'|'M'|'G'|'T');


START_NATIONAL_STRING_LITERAL:       'N' SQUOTA_STRING;
STRING_LITERAL:                      DQUOTA_STRING | SQUOTA_STRING | BQUOTA_STRING;
DECIMAL_LITERAL:                     DEC_DIGIT+;
HEXADECIMAL_LITERAL:                 'X' '\'' (HEX_DIGIT HEX_DIGIT)+ '\''
                                     | '0X' HEX_DIGIT+;

STRING_CHARSET_NAME:                 '_' CHARSET_NAME;


DOT_ID:                              '.' ID_LITERAL;


ID:                                  ID_LITERAL;
REVERSE_QUOTE_ID:                    '`' ~'`'+ '`';
STRING_USER_NAME:                    (
                                       SQUOTA_STRING | DQUOTA_STRING
                                       | BQUOTA_STRING | ID_LITERAL
                                     ) '@'
                                     (
                                       SQUOTA_STRING | DQUOTA_STRING
                                       | BQUOTA_STRING | ID_LITERAL
                                     );


fragment CHARSET_NAME:               UTF8 ;

fragment EXPONENT_NUM_PART:          'E' [-+]? DEC_DIGIT+;
fragment ID_LITERAL:                 [A-Z_$0-9]*?[A-Z_$]+?[A-Z_$0-9]*;
fragment DQUOTA_STRING:              '"' ( '\\'. | '""' | ~('"'| '\\') )* '"';
fragment SQUOTA_STRING:              '\'' ('\\'. | '\'\'' | ~('\'' | '\\'))* '\'';
fragment BQUOTA_STRING:              '`' ( '\\'. | '``' | ~('`'|'\\'))* '`';
fragment HEX_DIGIT:                  [0-9A-F];
fragment DEC_DIGIT:                  [0-9];
fragment BIT_STRING_L:               'B' '\'' [01]+ '\'';

ERROR_RECONGNIGION:                  .    -> channel(ERRORCHANNEL);
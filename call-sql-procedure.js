import connection from './mysql-connect.js'

/**
 * Calls the specified SQL procedure with the supplied arguments.
 * 
 * 
 * @param procedure_name - the name of the procedure you'd like to call.
 * @param args           - array of arguments the procedure requires.
 *                         note: should be an array even if there's only 1 arg.
 * @param connection     - connection object to MySQL server, created in app.js.
 * @param successFunc    - function that defines desired behavior if the procedure
 *                         call returns successfully. ResultSet of procedure will be
 *                         passed to it as an argument.
 * @param failFunc       - Recommended; defines desired behavior if procedure returns
 *                         with an error.
 */
const callProcedure = async (procedure_name, args, successFunc, failFunc) => {
    let sqlStr = `CALL ${procedure_name} (`
    let numArgs = args.length
    if (numArgs != 0) {
        for (let i = 1; i < numArgs; i++) {
            sqlStr += '?, '
        }
        sqlStr += '?'
    }
    sqlStr += ')'
    connection.query(sqlStr, args, (error, results, fields) => {
       if (error && failFunc) {
           failFunc(error);
       }
        successFunc(results)
    })
}
export default callProcedure;

/* 
Example call:
let args = ['mgb132', 'p', 'e4', 'Viewer', null, 'mel', 'ba']
const results = callProcedure('add_user', args,
                               results => console.log(results),
                               error => console.log(error))

*/
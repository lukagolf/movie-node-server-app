import connection from './mysql-connect.js'

/**
 * Calls the specified SQL procedure with the supplied arguments.
 * 
 * 
 * @param procedure_name - the name of the procedure you'd like to call.
 * @param args           - array of arguments the procedure requires.
 *                         note: should be an array even if there's only 1 arg.
 * 
 * @returns A Promise object that returns requested data upon resolving, or 
 *          rejects when it throws an error. Use async/await or .then() when 
 *          calling this function. 
 * 
 *          The data will be an array of objects returned by MySQL, even if
 *          MySQL only returned 1 object.
 */
const callProcedure = (procedure_name, args=[]) => {
    return new Promise((resolve, reject) => {
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
            if (error) {
                reject(error);
            } else {
                resolve(results[0])
            }
        })
    });
}
export default callProcedure;
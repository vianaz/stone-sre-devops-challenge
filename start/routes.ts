/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
import db from '@adonisjs/lucid/services/db'

router.get('/health', async ({ response }) => {
  const result = await db.rawQuery('SELECT 1')

  if (result.error) {
    response.status(500).send({
      status: 'error',
      message: 'Database connection error',
    })
  }

  return {
    status: 'ok',
    db: result.rows,
  }
})

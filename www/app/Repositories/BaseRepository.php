<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;
use App\Repositories\Interfaces\BaseRepositoryInterface;
use Illuminate\Support\Facades\Log;

class BaseRepository implements BaseRepositoryInterface
{
    /**
     * @var Illuminate\Database\Eloquent\Model
     */
    protected $model;

    public function __construct(Model $model)
    {
        $this->model = $model;
    }

    /**
     * Get a model based on id from the database.
     * 
     * @param string|int $id
     * 
     * @return Illuminate\Database\Eloquent\Model
     */
    public function find($id): ?Model
    {
        Log::debug(__CLASS__ . ' ' . __FUNCTION__ . ' called');
        return $this->model->find($id);
    }

    /**
     * Get all models from database.
     * 
     * @return \Illuminate\Database\Eloquent\Collection
     */
    public function all(): Collection
    {
        Log::debug(__CLASS__ . ' ' . __FUNCTION__ . ' called');
        return $this->model->all();
    }

    /**
     * Create a new model in database.
     * 
     * @param array $attributes
     * 
     * @return Illuminate\Database\Eloquent\Model
     */
    public function create($attributes): Model
    {
        Log::debug(__CLASS__ . ' ' . __FUNCTION__ . ' called');
        return $this->model->create($attributes);
    }

    /**
     * Update a model in database.
     * 
     * @param string|int $id
     * @param array $attributes
     * 
     * @return bool
     */
    public function update($id, $attributes): bool
    {
        Log::debug(__CLASS__ . ' ' . __FUNCTION__ . ' called');
        $model = $this->model->findOrFail($id);
        return $model->update($attributes);
    }

    /**
     * Delete a model from database.
     * 
     * @param string|int $id
     * 
     * @return bool
     */
    public function destroy($id): bool
    {
        Log::debug(__CLASS__ . ' ' . __FUNCTION__ . ' called');
        return $this->model->destroy($id);
    }
}


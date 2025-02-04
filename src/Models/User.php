<?php

namespace App\Models;

class User
{
    protected string $name = '';

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function __toString(): string
    {
        return "Hello {$this->name}!!!";
    }
}

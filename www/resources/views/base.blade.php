<!DOCTYPE html>
<html lang="{{ config('app.locale') }}">

@include('partials._head')

<body>
    <main>
        @yield('content')
    </main>
    <footer>
        @include('partials/_footer')
    </footer>
</body>
</html>
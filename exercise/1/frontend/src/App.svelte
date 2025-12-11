<script>
  import UnemploymentChart from './UnemploymentChart.svelte';
</script>

<main>
  <div class="container">
    <header>
      <h1>Unemployment Trends with AI-Generated Narratives</h1>
      <p class="subtitle">
        Explore unemployment patterns across demographics (2019-2024).
        Hover over lines or select filters to see AI-generated contextual explanations.
      </p>
    </header>

    <UnemploymentChart />

    <footer>
      <p><strong>Note:</strong> This is a demonstration using fictional data with realistic patterns showing marginalization effects during COVID-19.</p>
    </footer>
  </div>
</main>

<style>
  :global(body) {
    margin: 0;
    padding: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
    background: #f5f5f5;
    color: #333;
  }

  main {
    padding: 2rem;
    max-width: 1400px;
    margin: 0 auto;
  }

  .container {
    background: white;
    border-radius: 8px;
    padding: 2rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  header {
    margin-bottom: 2rem;
    border-bottom: 3px solid #2c3e50;
    padding-bottom: 1rem;
  }

  h1 {
    margin: 0 0 0.5rem 0;
    font-size: 2rem;
    color: #2c3e50;
  }

  .subtitle {
    margin: 0;
    font-size: 1rem;
    color: #7f8c8d;
    line-height: 1.5;
  }

  footer {
    margin-top: 2rem;
    padding-top: 1rem;
    border-top: 1px solid #ecf0f1;
    font-size: 0.9rem;
    color: #7f8c8d;
  }

  footer p {
    margin: 0.5rem 0;
  }

  .tech-note {
    background: #ecf0f1;
    padding: 0.75rem;
    border-radius: 4px;
    font-size: 0.85rem;
  }
</style>

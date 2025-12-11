<script>
  import { onMount, tick } from 'svelte';
  import * as d3 from 'd3';

  // Data and state
  let allCombinations = [];
  let tooltipsData = {};
  let loading = true;
  let chartDiv;

  // Filter selections
  let selectedRace = 'Black';
  let selectedGender = 'Women';
  let selectedAge = '16-24';
  let selectedEducation = 'College graduate';

  // Filter options
  let raceOptions = [];
  let genderOptions = [];
  let ageOptions = [];
  let educationOptions = [];

  // Computed
  let selectedComboId = '';
  let tooltipText = '';

  onMount(async () => {
    try {
      // Load combination data
      const dataResponse = await fetch('/data/unemploymentCombinations.json');
      const jsonData = await dataResponse.json();

      // Extract filter options from metadata
      raceOptions = jsonData.metadata.categories.race;
      genderOptions = jsonData.metadata.categories.gender;
      ageOptions = jsonData.metadata.categories.age;
      educationOptions = jsonData.metadata.categories.education;

      // Convert combinations object to array
      allCombinations = Object.entries(jsonData.combinations).map(([id, combo]) => ({
        id,
        race: combo.race,
        gender: combo.gender,
        age: combo.age,
        education: combo.education,
        data: combo.data.map(d => ({
          date: new Date(d.date),
          unemployment_rate: d.unemployment_rate
        }))
      }));

      // Load tooltips
      try {
        const tooltipsResponse = await fetch('/tooltips.json');
        tooltipsData = await tooltipsResponse.json();
      } catch (e) {
        console.warn('Could not load tooltips.json');
      }

      loading = false;
      await tick();
    } catch (error) {
      console.error('Error loading data:', error);
      loading = false;
    }
  });

  // Reactive: update selected combination ID
  $: selectedComboId = `${selectedRace}|${selectedGender}|${selectedAge}|${selectedEducation}`;

  // Reactive: update tooltip
  $: if (selectedComboId && tooltipsData) {
    tooltipText = tooltipsData[selectedComboId] || "";
  }

  // Reactive: get selected combination stats
  $: selectedCombo = allCombinations.find(c => c.id === selectedComboId);
  $: currentRate = selectedCombo ?
    selectedCombo.data[selectedCombo.data.length - 1].unemployment_rate : 0;

  function drawChart() {
    if (!chartDiv || allCombinations.length === 0) return;

    // Clear existing chart
    d3.select(chartDiv).selectAll('*').remove();

    const margin = { top: 60, right: 20, bottom: 40, left: 60 };
    const width = 900 - margin.left - margin.right;
    const height = 500 - margin.top - margin.bottom;

    const svg = d3.select(chartDiv)
      .append('svg')
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
      .append('g')
      .attr('transform', `translate(${margin.left},${margin.top})`);

    // Scales
    const allDates = allCombinations[0].data.map(d => d.date);
    const x = d3.scaleTime()
      .domain(d3.extent(allDates))
      .range([0, width]);

    const allRates = allCombinations.flatMap(c => c.data.map(d => d.unemployment_rate));
    const y = d3.scaleLinear()
      .domain([0, d3.max(allRates) * 1.1])
      .range([height, 0]);

    // Axes
    svg.append('g')
      .attr('transform', `translate(0,${height})`)
      .call(d3.axisBottom(x).ticks(6))
      .style('font-size', '12px');

    svg.append('g')
      .call(d3.axisLeft(y).ticks(6).tickFormat(d => d + '%'))
      .style('font-size', '12px');

    // Grid lines
    svg.append('g')
      .attr('class', 'grid')
      .call(d3.axisLeft(y).tickSize(-width).tickFormat(''))
      .style('stroke', '#e0e0e0')
      .style('stroke-dasharray', '2,2');

    // COVID-19 marker
    const covidDate = new Date('2020-03-01');
    svg.append('line')
      .attr('x1', x(covidDate))
      .attr('x2', x(covidDate))
      .attr('y1', 0)
      .attr('y2', height)
      .attr('stroke', '#ff6b6b')
      .attr('stroke-width', 2)
      .attr('stroke-dasharray', '4,4');

    svg.append('text')
      .attr('x', x(covidDate) + 5)
      .attr('y', 15)
      .text('COVID-19')
      .style('font-size', '11px')
      .style('fill', '#ff6b6b');

    // Line generator
    const line = d3.line()
      .x(d => x(d.date))
      .y(d => y(d.unemployment_rate))
      .curve(d3.curveMonotoneX);

    // Style all combinations based on selection
    const styledCombinations = allCombinations.map(combo => ({
      ...combo,
      selected: combo.id === selectedComboId,
      color: combo.id === selectedComboId ? '#e74c3c' : '#ccc',
      strokeWidth: combo.id === selectedComboId ? 3 : 0.5,
      opacity: combo.id === selectedComboId ? 1 : 0.15
    }));

    // Draw all lines (selected line drawn last so it's on top)
    const unselectedLines = styledCombinations.filter(c => !c.selected);
    const selectedLines = styledCombinations.filter(c => c.selected);
    const drawOrder = [...unselectedLines, ...selectedLines];

    svg.selectAll('.unemployment-line')
      .data(drawOrder)
      .join('path')
      .attr('class', 'unemployment-line')
      .attr('d', d => line(d.data))
      .attr('stroke', d => d.color)
      .attr('stroke-width', d => d.strokeWidth)
      .attr('opacity', d => d.opacity)
      .attr('fill', 'none')
      .style('pointer-events', 'none');
  }

  // Redraw when filters or data changes
  $: if (allCombinations.length > 0 && chartDiv && selectedComboId) {
    drawChart();
  }

</script>

{#if loading}
  <div class="loading">Loading data...</div>
{:else}
  <div class="container">
    <!-- Filter controls -->
    <div class="filters">
      <div class="filter-group">
        <label for="race">Race</label>
        <select id="race" bind:value={selectedRace}>
          {#each raceOptions as race}
            <option value={race}>{race}</option>
          {/each}
        </select>
      </div>

      <div class="filter-group">
        <label for="gender">Gender</label>
        <select id="gender" bind:value={selectedGender}>
          {#each genderOptions as gender}
            <option value={gender}>{gender}</option>
          {/each}
        </select>
      </div>

      <div class="filter-group">
        <label for="age">Age</label>
        <select id="age" bind:value={selectedAge}>
          {#each ageOptions as age}
            <option value={age}>{age}</option>
          {/each}
        </select>
      </div>

      <div class="filter-group">
        <label for="education">Education</label>
        <select id="education" bind:value={selectedEducation}>
          {#each educationOptions as edu}
            <option value={edu}>{edu}</option>
          {/each}
        </select>
      </div>
    </div>

    <!-- Chart and narrative -->
    <div class="chart-container">
      <div class="chart-area">
        <!-- Narrative box (top-right overlay) -->
        {#if selectedCombo}
          <div class="narrative-box">
            <div class="narrative-stat">
              <div class="narrative-label">UNEMPLOYMENT RATE</div>
              <div class="narrative-value">{currentRate.toFixed(1)}%</div>
            </div>
            <div class="narrative-text">{tooltipText}</div>
          </div>
        {/if}

        <!-- Chart SVG -->
        <div id="chart" bind:this={chartDiv}></div>
      </div>
    </div>

  </div>
{/if}

<style>
  .container {
    max-width: 1200px;
    margin: 2rem auto;
    padding: 0 1rem;
  }

  .filters {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-bottom: 2rem;
    padding: 1.5rem;
    background: #f8f9fa;
    border-radius: 8px;
  }

  .filter-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .filter-group label {
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #666;
  }

  .filter-group select {
    padding: 0.75rem;
    border: 2px solid #e0e0e0;
    border-radius: 4px;
    font-size: 0.95rem;
    background: white;
    cursor: pointer;
    transition: border-color 0.2s;
  }

  .filter-group select:hover {
    border-color: #ccc;
  }

  .filter-group select:focus {
    outline: none;
    border-color: #e74c3c;
  }

  .chart-container {
    margin-bottom: 2rem;
  }

  .chart-area {
    position: relative;
  }

  /* NYT-style narrative box */
  .narrative-box {
    position: absolute;
    top: 0;
    right: 0;
    width: 300px;
    background: white;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 1.25rem;
    z-index: 10;
    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
  }

  .narrative-stat {
    margin-bottom: 0.75rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #eee;
  }

  .narrative-label {
    font-size: 0.7rem;
    color: #666;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-bottom: 0.25rem;
    font-weight: 600;
  }

  .narrative-value {
    font-size: 2.5rem;
    font-weight: 700;
    color: #e74c3c;
    line-height: 1;
  }

  .narrative-subtitle {
    font-size: 0.8rem;
    color: #666;
    margin-bottom: 0.75rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #eee;
    line-height: 1.4;
  }

  .narrative-text {
    font-size: 0.95rem;
    line-height: 1.6;
    color: #333;
  }

  .info {
    text-align: center;
    color: #666;
    font-size: 0.9rem;
  }

  .info p {
    margin: 0.5rem 0;
  }

  .info .highlight {
    color: #e74c3c;
    font-weight: 600;
  }

  .loading {
    text-align: center;
    padding: 4rem;
    color: #95a5a6;
    font-size: 1.2rem;
  }

  #chart {
    margin: 2rem 0;
    min-height: 500px;
  }

  @media (max-width: 900px) {
    .filters {
      grid-template-columns: 1fr;
    }

    .narrative-box {
      position: static;
      margin-bottom: 1rem;
      width: 100%;
    }
  }
</style>
